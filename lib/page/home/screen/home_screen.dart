import 'package:drift/drift.dart' as drift;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_app/database/database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchData();
    });

    super.initState();
  }

  bool isAllSelection = false;
  final TextEditingController textController = TextEditingController();
  AppDatabase db = AppDatabase();
  List<TodoResponseData> res = [];

  Future<void> fetchData() async {
    res = await db.todoResponseDao.fetchTodoResponsesForSync();
    if (res.isEmpty) {
      isAllSelection = false;
    }
    setState(() {});
  }

  Map<int, bool> selectedList = {};
  Widget? anima;
  Future<void> submitFun({TodoResponseData? editData}) async {
    final nav = Navigator.of(context);
    DateTime currentDate = DateTime.now();
    String formattedDate =
        DateFormat('MM/dd/yyyy | hh:mma').format(currentDate);
    if (editData != null) {
      await db.todoResponseDao.updateTodoResponseRecord(
          id: editData.id,
          value: textController.text,
          updateDate: formattedDate);
    } else {
      if (textController.text.isNotEmpty) {
        await db.todoResponseDao.addTodoResponse(TodoResponseCompanion(
          data: drift.Value(textController.text),
          createdAt: drift.Value(formattedDate),
        ));
        setState(() {
          anima = Lottie.asset('assets/json/party_popper.json');
        });
        Future.delayed(const Duration(seconds: 3)).then((_) {
          setState(() {
            anima = null;
          });
        });
      }
    }
    await fetchData();
    if (mounted) {
      nav.pop();
    }
    textController.clear();
  }

  Future<void> showAlertDialog({TodoResponseData? editData}) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          clipBehavior: Clip.antiAlias,
          contentPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          content: Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: 0.9,
                  child: Image.asset(
                    'assets/png/bg_image.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Dialog content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        editData != null ? "Edit" : "Add",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      TextField(
                        controller: textController,
                        decoration: const InputDecoration(
                          hintText: "Type here",
                          hintStyle: TextStyle(color: Colors.white70),
                        ),
                        onSubmitted: (_) => submitFun(editData: editData),
                        style: const TextStyle(color: Colors.white),
                        maxLines: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            child: const Text("Cancel",
                                style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                          ),
                          TextButton(
                            child: const Text("Submit",
                                style: TextStyle(color: Colors.white)),
                            onPressed: () async =>
                                submitFun(editData: editData),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: isAllSelection
            ? null
            : FloatingActionButton(
                onPressed: () async {
                  textController.clear();
                  await showAlertDialog();
                },
                child: const Icon(Icons.add),
              ),
        bottomSheet: isAllSelection
            ? InkWell(
                onTap: () async {
                  if (selectedList.isNotEmpty) {
                    await db.todoResponseDao.deleteListOfTodoResponseRecords(
                        selectedList.entries
                            .where((entry) => entry.value == true)
                            .map((entry) => entry.key)
                            .toList());
                    selectedList.entries
                        .where((entry) => entry.value == true)
                        .map((entry) => selectedList.remove(entry.key));
                    fetchData();
                  }
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Colors.grey),
                  child: const Center(
                    child: Icon(
                      CupertinoIcons.delete_simple,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            : null,
        appBar: AppBar(
          flexibleSpace: Image.asset(
            "assets/png/appbar_bg.png",
            fit: BoxFit.fill,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          toolbarHeight: 75,
          title: isAllSelection
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isAllSelection = !isAllSelection;
                    });
                    setState(() {
                      for (var resItem in res) {
                        selectedList[resItem.id] = false;
                      }
                    });
                  },
                  icon: const Icon(Icons.close))
              : Text(
                  "Todo",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: Colors.white),
                ),
          actions: [
            if (isAllSelection)
              IconButton(
                onPressed: () {
                  bool anyTrue = selectedList.values.any((val) => val == false);
                  if (anyTrue) {
                    setState(() {
                      for (var resItem in res) {
                        selectedList[resItem.id] = true;
                      }
                    });
                  } else {
                    setState(() {
                      for (var resItem in res) {
                        selectedList[resItem.id] = false;
                      }
                    });
                  }
                },
                icon: selectedList.values.any((val) => val == false)
                    ? const Icon(Icons.select_all)
                    : const Icon(Icons.deselect_outlined),
              ),
            const SizedBox(width: 10)
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await fetchData();
          },
          child: res.isEmpty
              ? Center(child: Lottie.asset('assets/json/no_data.json'))
              : Stack(
                  children: [
                    if (anima != null) anima!,
                    SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final item = res[index];
                                  return Container(
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage(
                                          "assets/png/card_bg.png",
                                        ),
                                        colorFilter: ColorFilter.mode(
                                          Colors.red,
                                          BlendMode.modulate,
                                        ),
                                      ),
                                    ),
                                    child: Slidable(
                                      enabled: !isAllSelection,
                                      endActionPane: ActionPane(
                                        extentRatio: 0.18,
                                        motion: const BehindMotion(),
                                        children: [
                                          SlidableAction(
                                              onPressed: ((context) async {
                                                await db.todoResponseDao
                                                    .deleteTodoResponseRecord(
                                                        item.id);
                                                selectedList.remove(item.id);
                                                await fetchData();
                                              }),
                                              backgroundColor:
                                                  Colors.transparent,
                                              foregroundColor: Colors.black,
                                              icon: (Icons.delete_outline),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(50))),
                                        ],
                                      ),
                                      child: GestureDetector(
                                        onTap: () async {
                                          if (!isAllSelection) {
                                            String formattedDate = DateFormat(
                                                    'MM/dd/yyyy | hh:mma')
                                                .format(DateTime.now());
                                            await db.todoResponseDao
                                                .updateTodoResponseRecord(
                                                    id: item.id,
                                                    isCompleted:
                                                        !item.isCompleted,
                                                    updateDate: formattedDate);
                                            fetchData();
                                          } else {
                                            setState(() {
                                              if (selectedList[item.id] !=
                                                  null) {
                                                selectedList[item.id] =
                                                    !selectedList[item.id]!;
                                              } else {
                                                selectedList[item.id] = true;
                                              }
                                            });
                                          }
                                        },
                                        onLongPress: () {
                                          setState(() {
                                            isAllSelection = !isAllSelection;
                                          });
                                          if (isAllSelection) {
                                            setState(() {
                                              selectedList[item.id] = true;
                                            });
                                          }
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: const AssetImage(
                                                "assets/png/card_bg.png",
                                              ),
                                              colorFilter: ColorFilter.mode(
                                                item.isCompleted
                                                    ? Colors.grey.shade100
                                                    : Colors.pink.shade50,
                                                BlendMode.modulate,
                                              ),
                                            ),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black12,
                                                offset: Offset(8, 12),
                                                blurRadius: 12,
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Visibility(
                                                      visible: isAllSelection,
                                                      child: Checkbox(
                                                          value: selectedList[
                                                                  item.id] ??
                                                              false,
                                                          onChanged:
                                                              (newVal) async {
                                                            setState(() {
                                                              selectedList[
                                                                      item.id] =
                                                                  newVal ??
                                                                      false;
                                                            });
                                                          }),
                                                    ),
                                                    Flexible(
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          item.data,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headlineSmall
                                                                  ?.copyWith(
                                                                    decoration: item
                                                                            .isCompleted
                                                                        ? TextDecoration
                                                                            .lineThrough
                                                                        : null,
                                                                  ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Visibility(
                                                        visible: isAllSelection ==
                                                                true
                                                            ? false
                                                            : item.isCompleted ==
                                                                false,
                                                        child: IconButton(
                                                          onPressed: () {
                                                            textController
                                                                    .text =
                                                                item.data;
                                                            showAlertDialog(
                                                                editData: item);
                                                          },
                                                          icon: const Icon(
                                                              Icons.edit),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Text(
                                                  "Created At : ${item.createdAt}",
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: CupertinoColors
                                                          .black),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 20),
                                itemCount: res.length),
                            const SizedBox(height: 50),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ));
  }
}
