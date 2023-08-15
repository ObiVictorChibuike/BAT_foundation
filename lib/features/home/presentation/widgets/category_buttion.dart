import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final String? title;
  final int index;
  final Color? color;
  const CategoryButton({super.key, this.title, this.color, required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(padding: const EdgeInsets.symmetric(vertical: 10), margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(8)),
          child: Center(child: Text(title ?? "", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black45, fontSize: 16),)),
        ),
        const SizedBox(height: 2,),
        Container(width: 60, height: 2, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),)
      ],
    );
  }
}

class CategoryButtonModel{
  final String buttonTitle;
  CategoryButtonModel(this.buttonTitle);
}
