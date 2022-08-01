import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class CustomProgress{

  final BuildContext context;


  CustomProgress(this.context);

  ProgressDialog? progressDialog;

  buildProgress(){
    progressDialog = ProgressDialog(context);

    progressDialog!.style(
        message: 'Please wait...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: const CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: const TextStyle(
            color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w600)
    );
  }

  startProgress() async{
    await progressDialog!.show();
  }

  stopProgress() async{
    await progressDialog!.hide();
  }
}