import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/features/approval_system_module/common/widgets/simmers.dart';


class OpdScreenSimmer extends StatelessWidget {
  const OpdScreenSimmer({super.key});


  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        children: [
          LineGraphShimmer(),
          CardListShimmer()
        ],
      )
    );
  }

}

            