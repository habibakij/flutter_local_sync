
import 'package:flutter/material.dart';
import 'data_model.dart';
import 'database_healper.dart';

class DataEditPage extends StatefulWidget {
  bool isUpdate= false;
  DataStoredModel? dataStoredModel;
  DataEditPage({super.key, this.dataStoredModel, required this.isUpdate});
  @override
  State<DataEditPage> createState() => _DataEditPage();
}

class _DataEditPage extends State<DataEditPage> {

  TextEditingController nameController= TextEditingController();
  TextEditingController designationController= TextEditingController();
  TextEditingController companyController= TextEditingController();
  TextEditingController experienceController= TextEditingController();

  DatabaseHelper helper= DatabaseHelper();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.isUpdate == true) {
      nameController.text = widget.dataStoredModel!.name.toString();
      designationController.text = widget.dataStoredModel!.designation.toString();
      companyController.text = widget.dataStoredModel!.company.toString();
      experienceController.text = widget.dataStoredModel!.experience.toString();
    }
    return Scaffold(
      appBar: AppBar(title: const Text("SQlite Database")),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [

            Container(
              padding: const EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                border: Border.all(color: const Color(0xFFB2BAFF)),
              ),
              alignment: Alignment.centerLeft,
              child: TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  focusColor: Colors.white,
                  hintText: "name",
                ),
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                border: Border.all(color: const Color(0xFFB2BAFF)),
              ),
              alignment: Alignment.centerLeft,
              child: TextFormField(
                controller: designationController,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  focusColor: Colors.white,
                  hintText: "designation",
                ),
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                border: Border.all(color: const Color(0xFFB2BAFF)),
              ),
              alignment: Alignment.centerLeft,
              child: TextFormField(
                controller: companyController,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  focusColor: Colors.white,
                  hintText: "company",
                ),
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 20),
              padding: const EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                border: Border.all(color: const Color(0xFFB2BAFF)),
              ),
              alignment: Alignment.centerLeft,
              child: TextFormField(
                controller: experienceController,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  focusColor: Colors.white,
                  hintText: "experience",
                ),
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: (){
                _saveDatabase(context);
              },
              child: const Text("Submit"),
            ),

          ],
        ),
      ),

    );
  }

  void _saveDatabase(BuildContext context) async {
    Navigator.pop(context, true);
    int result;
    if(widget.isUpdate == true){
      result= await helper.updateData(DataStoredModel(
        id: widget.dataStoredModel!.id!.toInt(),
        name: nameController.text.toString(),
        designation: designationController.text.toString(),
        company: companyController.text.toString(),
        experience: int.parse(experienceController.text.toString()),
      ));
    } else {
      result= await helper.insertData(DataStoredModel(
        name: nameController.text.toString(),
        designation: designationController.text.toString(),
        company: companyController.text.toString(),
        experience: int.parse(experienceController.text.toString()),
      ));
    }
    if(result != 0){
      _dialog(context, "Status", "Data save successfully");
    } else {
      _dialog(context, "Status", "Data not saved");
    }
  }

  void _dialog(BuildContext context, String title, String message){
    AlertDialog alertDialog= AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

}