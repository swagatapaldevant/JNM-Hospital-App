import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/features/approval_system_module/common/widgets/graph_and_card_screen_simmer.dart';
import 'package:jnm_hospital_app/features/approval_system_module/common/widgets/simmers.dart';

class DashboardSimmer extends StatelessWidget {
  const DashboardSimmer({super.key});

  
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomShimmer(height: 10, width: 30),
              SizedBox(height: 10,),
              CustomShimmer(height: 20, width: 200),
              SizedBox(height: 10,),
              CustomShimmer(height: 10, width: 30),
              SizedBox(height: 20,),
              CustomShimmer(height: 300, width: 330),
              SizedBox(height: 20,),
              GraphHeaderSimmer(),
              SizedBox(height: 20,),
              GraphWithContainerSimmer()
            ],
          ),
        ),
      ),
    );
  }
}