import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';


// class SupportScreenScaffold extends StatefulWidget{
class SupportScreenScaffold extends StatefulWidget {
  const SupportScreenScaffold({super.key});

  @override
  _SupportScreenScaffoldState createState() => _SupportScreenScaffoldState();
}
class _SupportScreenScaffoldState extends State<SupportScreenScaffold> {

  bool showProgress = false;
  String email="", password="";
  String date_of_birth="";
  int year=0;
  int day=0;
  int month=0;

  TextEditingController date_controller=new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Date Picker"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Registration Page",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20.0),
              ),
              SizedBox(
                height: 50.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value; //get the value entered by user.
                },

                decoration: InputDecoration(
                    hintText: "Enter your Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)))),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value; //get the value entered by user.
                },
                decoration: InputDecoration(
                    hintText: "Enter your Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)))),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextButton(
                onPressed: () {
                  var parts = date_of_birth.split('/');
                  if(parts.length>=2)
                  {

                    year = int.parse(parts[2].trim());
                    month = int.parse(parts[1].trim());
                    day = int.parse(parts[0].trim());
                  }


                  showDialog(

                      context: context, builder: (context){
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      actions: <Widget>[
                        Container(
                          height: 30,
                          child: MaterialButton(
                            color: Colors.green,
                            child: Text('Set',style: TextStyle(color: Colors.white),),
                            onPressed: () {
                              setState(() {
                                date_of_birth=date_controller.text;
                              });

                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            setState(() {
                              date_controller.text=date_of_birth;
                            });

                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                      content: Container(

                        height: 300,
                        width:300,
                        child: SfDateRangePicker(
                          initialSelectedDate: DateTime(year,month,day),
                          onSelectionChanged: _onSelectionChanged,
                          selectionMode: DateRangePickerSelectionMode.single,

                        ),
                      ),
                    );
                  });
                },
                child: Column(
                  children: [
                    Text("Select DOB"),
                    TextField(
                      textAlign: TextAlign.center,
                      controller: date_controller,
                      enableInteractiveSelection: false,
                      enabled: false,
                      focusNode: FocusNode(),

                      decoration: InputDecoration(
                          hintText: "Date Of Birth",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(32.0)))),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Material(
                elevation: 5,
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(32.0),
                child: MaterialButton(
                  onPressed: () async {


                  },
                  minWidth: 200.0,
                  height: 45.0,
                  child: Text(
                    "Register",
                    style:
                    TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              GestureDetector(
                onTap: () {

                },
                child: Text(
                  "Already Registred? Login Now",
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.w900),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    /// The argument value will return the changed date as [DateTime] when the
    /// widget [SfDateRangeSelectionMode] set as single.
    ///
    /// The argument value will return the changed dates as [List<DateTime>]
    /// when the widget [SfDateRangeSelectionMode] set as multiple.
    ///
    /// The argument value will return the changed range as [PickerDateRange]
    /// when the widget [SfDateRangeSelectionMode] set as range.
    ///
    /// The argument value will return the changed ranges as
    /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
    /// multi range.
    setState(() {
      if (args.value is PickerDateRange) {

      } else if (args.value is DateTime) {
        date_controller.text = DateFormat('dd/MM/yyyy')
            .format(args.value)
            .toString();;
      } else if (args.value is List<DateTime>) {

      } else {

      }
    });
  }
}



