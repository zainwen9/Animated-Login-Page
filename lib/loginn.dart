import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class loginn extends StatefulWidget {
  const loginn({Key? key}) : super(key: key);

  @override
  State<loginn> createState() => _loginnState();
}

class _loginnState extends State<loginn> {

  var emailController=TextEditingController();
  var passwordController=TextEditingController();

  var animationLink='assets/login.riv';
  late SMITrigger failTrigger,successTrigger;
  late SMIBool isChecking,isHandsUp;
  late SMINumber lookNum;
  Artboard? artboard;
  late StateMachineController? stateMachineController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initArtboard();//start animation
  }
  initArtboard(){
    rootBundle.load(animationLink).then((value){
      final file=RiveFile.import(value);
      final art=file.mainArtboard;
      stateMachineController=StateMachineController.fromArtboard(art, "Login Machine")!;
      if(stateMachineController!=null){
        art.addController(stateMachineController!);
        for(var element in stateMachineController!.inputs){

         if(element.name=="isChecking"){
           isChecking=element as SMIBool;
         }
         else if(element.name=="isHandsUp"){
           isHandsUp=element as SMIBool;
         }
         else if(element.name=="trigSuccess"){
           successTrigger=element as SMITrigger;
         }
         else if(element.name=="trigFail"){
           failTrigger=element as SMITrigger;
         }
         else if(element.name=='numLook'){
           lookNum=element as SMINumber;
         }
        }
      }
      setState(() {
        artboard=art;
      });
    });
  }

  checking(){
    isHandsUp.change(false);
    isChecking.change(true);
    lookNum.change(0);
  }

  moveEyes(value){
    lookNum.change(value.length.toDouble());
  }

  handsUp(){
    isHandsUp.change(true);
    isChecking.change(false);
  }
  handsDown(){
    isHandsUp.change(false);
    isChecking.change(false);
  }

  login(){
    isHandsUp.change(false);
    isChecking.change(false);
    if(emailController.text=='flutter_works_'&&passwordController.text=='admin'){
      successTrigger.fire();
    }else{
      failTrigger.fire();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade500,
        title: Center(child: Text('@ flutter_works_')),
      ),
      backgroundColor: const Color(0xffd6e2ea),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           if(artboard!=null)
              SizedBox(
                width: 350,
                height: 300,
               child: Rive(artboard: artboard!),
              ),


            Container(
              alignment: Alignment.center,
              width: 400,
              padding: EdgeInsets.only(bottom: 15),
              margin: EdgeInsets.only(bottom: 15 * 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 15 * 2,
                        ),
                        TextField(
                          onTap: checking,
                         onChanged: ((value)=>moveEyes(value)),
                         controller: emailController,


                          decoration: InputDecoration(
                            fillColor: Color(0xffd6e2ea),
                            filled: true,
                            hintText: 'Email/Username',
                            prefixIcon: Icon(Icons.email),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: 15 * 2,
                        ),
                        TextField(
                          onTap: handsUp,
                          controller: passwordController,


                          decoration: InputDecoration(
                            fillColor: Color(0xffd6e2ea),
                            filled: true,
                            hintText: 'Password',
                            prefixIcon: Icon(Icons.password),
                            suffixIcon: GestureDetector(
                                onTap: handsDown,
                                child: Icon(Icons.remove_red_eye_rounded)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: 15 * 2,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.remember_me,
                            ),
                            Text('@flutter_works_'),
                            SizedBox(
                              width: 100,
                            ),
                            GestureDetector(
                              onTap: login(),

                              child: Container(
                                height: 50,
                                width: 100,
                                decoration: BoxDecoration(
                                    color: Colors.blue.shade500,
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: login,
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
