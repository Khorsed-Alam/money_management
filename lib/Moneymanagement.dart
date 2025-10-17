 import 'package:flutter/material.dart';

class Moneymanagement extends StatefulWidget {
   const Moneymanagement({super.key});

   @override
   State<Moneymanagement> createState() => _MoneymanagementState();
 }

 class _MoneymanagementState extends State<Moneymanagement> with SingleTickerProviderStateMixin{
 late TabController _tabController;
 List<Map<String,dynamic>> _expense=[];
 List<Map<String,dynamic>> _earning=[];


 double get totalExpense=> _expense.fold( 0,  (sum,item)=>sum+item['amount']);
 double get totalEarning=> _earning.fold( 0,  (sum,item)=>sum+item['amount']);

 double get balance=> totalEarning-totalExpense;

 
 void _addEntry(String title,double amount,DateTime date,bool isEarning){
   setState(() {
     if(isEarning){
       _earning.add({
         "title": title,
         "amount":amount,
         "date":date,

       });
     }else{
       _expense.add({
         "title":title,
        "amount": amount,
         "date": date,
       });
     }
   });
 }
 

 void initState(){super.initState();
   _tabController=TabController(length: 2, vsync: this);
 }

 void _showFABOption(BuildContext context){
                  showModalBottomSheet(context: context, builder: (context){
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              style:ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                      ),
                              onPressed: ( ){
                                Navigator.pop(context);
                                _showForm(isEarning: true);

                              }, child:  Text('Add Earning')),
                          ElevatedButton(
                              style:ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: ( ){
                                Navigator.pop(context);
                                _showForm(isEarning: false);
                              }, child:  Text('Add Earning')),
                        ],

                      ),
                    );
                  });
            }
            void _showForm({required bool isEarning }){
                  TextEditingController titleController=TextEditingController();
                  TextEditingController amountController=TextEditingController();
                  DateTime entryData=DateTime.now();
              showModalBottomSheet(context: context, builder: (context){
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        isEarning? 'Add Earning': 'Add Expense',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Amount',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                        backgroundColor: isEarning? Colors.green:Colors.red,
                                        ),
                                        onPressed: (){
                              if(titleController.text.isNotEmpty && amountController.text.isNotEmpty){
                                _addEntry(titleController.text, double.parse(amountController.text), entryData, isEarning);
                                Navigator.pop(context);
                                
                              }
                                        }, child: Text(isEarning? 'Add Earning ':'Add Expense',
                        style:
                          TextStyle(
                            fontSize: 16,

                          ),)),
                      )

                    ],
                  ),
                );
              });

            }

   @override
   Widget build(BuildContext context) {
     return  Scaffold(
       backgroundColor: Colors.grey.shade50,
       appBar: AppBar(
         backgroundColor: Colors.teal,
         title: Text('Money Management',style:
         TextStyle(
           fontSize: 20,
           fontWeight: FontWeight.bold,
         ),),

         bottom: TabBar(
           controller: _tabController,

             tabs: [
           Tab(text: 'Earning',icon: Icon(Icons.arrow_upward),),
           Tab(text: 'Expense' ,icon: Icon(Icons.arrow_downward),)

         ]),

       ),
       body: Column(
         children: [
           Row(
             children: [
                _buildSummeryCard(title: 'Earning', value: totalEarning, color: Colors.green),
                _buildSummeryCard(title: 'Expense', value: totalExpense, color: Colors.green),
                _buildSummeryCard(title: 'Balance', value: balance, color: Colors.green),

             ],
           ),
           Expanded(
             child: TabBarView(
                 controller: _tabController,
                 children: [
               _buildList(_earning, Colors.green, true),
               _buildList(_expense, Colors.red, false),

             ]),
           )
         ],
       ),
       
       floatingActionButton: FloatingActionButton(
         onPressed: ()=> _showFABOption( context),
         child: Icon(Icons.add),),

     );
   }
 }

 Widget _buildSummeryCard({required String title,required double value, required Color color}){
  return Expanded(
    child: Card(
      color: color,
      child:Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(title,style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),),
            Text(value.toString(),style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),)
          ],
        ),
      ),
    ),
  );
 }

 Widget _buildList(List<Map<String,dynamic>>items,Color color,bool isEarning){
  return ListView.builder(
    itemCount: items.length,
      itemBuilder: (context,index){
      return Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Icon(isEarning?  Icons.arrow_upward: Icons.arrow_downward),
          ),
          title: Text(items[index]['title']),
          subtitle: Text(items[index]['date'].toString()),
          trailing: Text(
            '৳ ${items[index]['amount']}',style:
            TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),

        ),
      );

  });

 }
