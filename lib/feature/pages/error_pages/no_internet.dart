import 'package:flutter/material.dart';
import 'package:src_kstu_app/components/colors.dart';


class noInternet extends StatelessWidget{
  Widget build(BuildContext context){
    return Container(
                                            width: double.infinity,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height -
                                                250,
                                            decoration: BoxDecoration(
                                                color: bottomColor,
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(30))),
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0,
                                                        vertical: 18.0),
                                                child: Container(
                                                  width: double.infinity,
                                                  // height: 300,
                                                  decoration: BoxDecoration(
                                                    color: topColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40),
                                                    image: DecorationImage(
                                                
                                                      image: ExactAssetImage(
                                                          'assets/images/wayera.png'),
                                                      fit: BoxFit.fitWidth,
                                                    ),
                                                  ),
                                                  child: Column(
                                                    
                                                    children: [
                                                      Container(
                                                        alignment:Alignment.center,
                                                        height:200,
                                                        // color:Colors.red,
                                                        child: Text(
                                                          'Aww snap, no internet connection!',
                                                          style: TextStyle(
                                                            color:
                                                                Colors.white,
                                                                fontWeight: FontWeight.bold,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )));
  }
}