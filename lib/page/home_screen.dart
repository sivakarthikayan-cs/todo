import 'package:drift/drift.dart' as drift;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
    if (editData != null) {
      await db.todoResponseDao.updateTodoResponseRecord(
          id: editData.id, value: textController.text);
    } else {
      if (textController.text.isNotEmpty) {
        await db.todoResponseDao.addTodoResponse(TodoResponseCompanion(
          data: drift.Value(textController.text),
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
          title: Text(editData != null ? "Edit" : "Add"),
          content: TextField(
              controller: textController,
              decoration: const InputDecoration(hintText: "Type here"),
              onSubmitted: (_) => submitFun(editData: editData)),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
                child: const Text("Submit"),
                onPressed: () async => submitFun(editData: editData)),
          ],
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
            : const Text("Todo"),
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
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: item.isCompleted
                                        ? Colors.grey.shade100
                                        : Colors.pink[50],
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(0, 0),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: Slidable(
                                    enabled: !isAllSelection,
                                    endActionPane: ActionPane(
                                      extentRatio: 0.20,
                                      motion: const StretchMotion(),
                                      children: [
                                        SlidableAction(
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(14),
                                            bottomRight: Radius.circular(14),
                                          ),
                                          onPressed: ((context) async {
                                            await db.todoResponseDao
                                                .deleteTodoResponseRecord(
                                                    item.id);
                                            await fetchData();
                                          }),
                                          backgroundColor: Colors.red.shade400,
                                          foregroundColor: Colors.white,
                                          icon: (Icons.delete_outline),
                                        ),
                                      ],
                                    ),
                                    child: InkWell(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      onTap: () async {
                                        if (!isAllSelection) {
                                          await db.todoResponseDao
                                              .updateTodoResponseRecord(
                                                  id: item.id,
                                                  isCompleted:
                                                      !item.isCompleted);
                                          fetchData();
                                        } else {
                                          setState(() {
                                            if (selectedList[item.id] != null) {
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
                                        height: 70,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: item.isCompleted
                                                ? Colors.grey.shade100
                                                : Colors.pink[50],
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Visibility(
                                                visible: isAllSelection,
                                                child: Checkbox(
                                                    value:
                                                        selectedList[item.id] ??
                                                            false,
                                                    onChanged: (newVal) async {
                                                      setState(() {
                                                        selectedList[item.id] =
                                                            newVal ?? false;
                                                      });
                                                    }),
                                              ),
                                              Flexible(
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    item.data,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineSmall
                                                        ?.copyWith(
                                                          decoration: item
                                                                  .isCompleted
                                                              ? TextDecoration
                                                                  .lineThrough
                                                              : null,
                                                        ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Visibility(
                                                  visible:
                                                      isAllSelection == true
                                                          ? false
                                                          : item.isCompleted ==
                                                              false,
                                                  child: IconButton(
                                                    onPressed: () {
                                                      textController.text =
                                                          item.data;
                                                      showAlertDialog(
                                                          editData: item);
                                                    },
                                                    icon:
                                                        const Icon(Icons.edit),
                                                  ),
                                                ),
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
      ),
    );
  }
}
