// import 'package:flutter/material.dart';

// class BloodInstructionsView extends StatelessWidget {
//   const BloodInstructionsView({super.key});

//   @override
//   Widget build(BuildContext) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         title: Text(
//           'Blood instructions',
//           style: TextStyle(
//             fontWeight: FontWeight.w500,
//             fontSize: 20,
//           ),
//         ),
//       ),
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.symmetric(
//           horizontal: 30,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: const [
//             Text(
//               "Additional tips before donating:",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w700,
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class BloodInstructionsView extends StatelessWidget {
  const BloodInstructionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      title: Text(
        'Blood instructions',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildSectionTitle("Additional tips before donating:"),
        ],
      ),
    );
  }

  static Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
