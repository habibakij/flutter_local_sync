
import 'dart:developer';
import 'package:flutter/material.dart';
import 'data_model.dart';
import 'database_healper.dart';
import 'edit_page.dart';

class DataListPage extends StatefulWidget {
  const DataListPage({Key? key}) : super(key: key);
  @override
  State<DataListPage> createState() => _DataListPageState();
}

class _DataListPageState extends State<DataListPage> {

  DatabaseHelper databaseHelper= DatabaseHelper();
  List<DataStoredModel> dataList= [];
  int count= 0;

  List<TextEditingController> textEditingControllers= [];
  List<bool> boolList= [];
  bool check= false;


  @override
  void initState() {
    updateList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Data list")),
      body: SingleChildScrollView(
        child: Column(
          children: [

            ListView.builder(
                itemCount: count,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index){
                  return Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.amber.withOpacity(.3),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "name: ${dataList[index].name}",
                              style: const TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            InkWell(
                              child: const Icon(Icons.edit, size: 20, color: Colors.grey),
                              onTap: () async {
                                log("update_id: ${dataList[index].id}");
                                bool result= await Navigator.push(context, MaterialPageRoute(builder: (context) => DataEditPage(dataStoredModel: dataList[index], isUpdate: true)));
                                if(result == true){
                                  updateList();
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "designation: ${dataList[index].designation}",
                              style: const TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            InkWell(
                              child: const Icon(Icons.delete, size: 20, color: Colors.grey),
                              onTap: (){
                                _delete(context, dataList[index]);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "company: ${dataList[index].company}",
                          style: const TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "experience: ${dataList[index].experience}",
                          style: const TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  );
                }),
            Container(height: 2, color: Colors.grey.withOpacity(.5)),
            const Text("Text Field"),
            ListView.builder(
              itemCount: count,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: ((context, index){
                textEditingControllers.add(TextEditingController());
                return Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    color: Colors.white70,
                    border: Border.all(color: Colors.amber),
                  ),
                  alignment: Alignment.centerLeft,
                  child: TextFormField(
                    controller: textEditingControllers[index],
                    style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusColor: Colors.white,
                      hintText: "index $index",
                      hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                );
              }),
              /*separatorBuilder: (context, index){
                return Container(height: 2, width: 200, color: Colors.red,);
              },*/
            ),
            Container(height: 2, color: Colors.grey.withOpacity(.5)),
            const Text("Check Box"),
            ListView.builder(
              itemCount: count,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: ((context, index){
                textEditingControllers.add(TextEditingController());
                return Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    color: Colors.white70,
                    border: Border.all(color: Colors.amber),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [

                      Text("check box $index"),
                      const SizedBox(width: 20),
                      Checkbox(
                        value: boolList[index],
                        activeColor: Colors.red,
                        checkColor: Colors.green,
                        onChanged: (value) {
                          setState(() {
                            boolList[index] = value!;
                            log("check_box:$index: ${boolList[index]}");
                          });
                        },
                      ),

                    ],
                  ),
                );
              }),
            ),

          ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool result= await Navigator.push(context, MaterialPageRoute(builder: (context) => DataEditPage(isUpdate: false)));
          if(result == true){
            updateList();
          }
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _delete(BuildContext context, DataStoredModel model) async {
    int result= await databaseHelper.deleteData(model.id!);
    if(result != 0){
      _showSnackBar(context, "Data deleted successfully");
      updateList();
    }
  }

  void _showSnackBar(BuildContext context, String message){
    final snackBar= SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void updateList() {
    var db= databaseHelper.initDatabase();
    db.then((database){
      Future<List<DataStoredModel>> model= databaseHelper.getAllConvertedData();
      model.then((modelDataList){
        dataList= modelDataList;
        count= modelDataList.length;
        boolList= List.filled(count, false, growable: true);
        setState(() {});
      });
    });
  }

}
