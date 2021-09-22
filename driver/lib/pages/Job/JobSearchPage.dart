import 'package:driver/adapter/JobAdapter.dart';
import 'package:driver/assets/AppColors.dart';
import 'package:fdottedline/fdottedline.dart';
import 'package:flutter/material.dart';

class JobSearchPage extends StatefulWidget{
  @override
  State<JobSearchPage> createState() => _JobSearchPageState();
}

class _JobSearchPageState extends State<JobSearchPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Color(0xFFE2E2E2),
        appBar: AppBar(
          elevation: 1,
          title: Text('Port Board'),
          backgroundColor: AppColors.darkBlue,
        ),
        body: Column(
          children: [
            DefaultTabController(
              length: 7,
              initialIndex: 0,
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 15, top: 15, right: 15),
                    child: TabBar(
                      onTap: (index){

                      },
                      indicatorColor: Colors.transparent,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        color: AppColors.green,
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black54,
                      isScrollable: true,
                      tabs: [
                        Container(
                          width: 60,
                          child: Column(
                            children: [
                              SizedBox(height: 5,),
                              Text('MON', style: TextStyle(fontSize: 23),),
                              SizedBox(height: 5,),
                              Text('Jul 01')
                            ],
                          ),
                        ),
                        Container(
                          width: 60,
                          child: Column(
                            children: [
                              SizedBox(height: 5,),
                              Text('TUE', style: TextStyle(fontSize: 23),),
                              SizedBox(height: 5,),
                              Text('Jul 02')
                            ],
                          ),
                        ),
                        Container(
                          width: 60,
                          child: Column(
                            children: [
                              SizedBox(height: 5,),
                              Text('WED', style: TextStyle(fontSize: 23),),
                              SizedBox(height: 5,),
                              Text('Jul 03')
                            ],
                          ),
                        ),
                        Container(
                          width: 60,
                          child: Column(
                            children: [
                              SizedBox(height: 5,),
                              Text('THU', style: TextStyle(fontSize: 23),),
                              SizedBox(height: 5,),
                              Text('Jul 04')
                            ],
                          ),
                        ),
                        Container(
                          width: 60,
                          child: Column(
                            children: [
                              SizedBox(height: 5,),
                              Text('FRI', style: TextStyle(fontSize: 23),),
                              SizedBox(height: 5,),
                              Text('Jul 05')
                            ],
                          ),
                        ),
                        Container(
                          width: 60,
                          child: Column(
                            children: [
                              SizedBox(height: 5,),
                              Text('SAT', style: TextStyle(fontSize: 23),),
                              SizedBox(height: 5,),
                              Text('Jul 06')
                            ],
                          ),
                        ),
                        Container(
                          width: 60,
                          child: Column(
                            children: [
                              SizedBox(height: 5,),
                              Text('SUN', style: TextStyle(fontSize: 23),),
                              SizedBox(height: 5,),
                              Text('Jul 07')
                            ],
                          ),
                        )
                      ]))])),
            Card(
              margin: EdgeInsets.all(15),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Find a job...'
                ),
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: 10,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return JobAdapter().item(context);
                    })
            ),

          ],
        ),
      ),
    );
  }
}