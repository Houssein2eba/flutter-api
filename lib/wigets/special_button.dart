
import 'package:flutter/material.dart';

class SpecialButton extends StatelessWidget{

  final String text;
  final VoidCallback onPress;
  final Color color;
  final Color textColor;
  const SpecialButton({super.key, required this.text, required this.onPress, required this.color, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      
      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        elevation: 2,
                      ),
      onPressed: onPress,

      child: Text(text, style: TextStyle(color: textColor),),
    );
  }

}