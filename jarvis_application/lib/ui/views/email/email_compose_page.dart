// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../../viewmodels/email_view_model.dart';
// import '../../widgets/app_drawer.dart';
//
// class EmailReplyScreen extends ConsumerWidget {
//   const EmailReplyScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final emailViewModel = ref.watch(emailViewModelProvider);
//     final viewModelNotifier = ref.read(emailViewModelProvider.notifier);
//
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.grey[100],
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           title: Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   color: Colors.blue[700],
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.mail_outline,
//                     color: Colors.white, size: 24),
//               ),
//               const SizedBox(width: 8),
//               const Text(
//                 'Email Reply',
//                 style: TextStyle(color: Colors.black, fontSize: 18),
//               ),
//               const Spacer(),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: Colors.blue[50],
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(Icons.local_fire_department,
//                         color: Colors.blue[700], size: 20),
//                     const SizedBox(width: 4),
//                     const Text(
//                       '73',
//                       style: TextStyle(
//                         color: Color(0xFF64748b),
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         drawer: const AppDrawer(),
//         body: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 padding: const EdgeInsets.all(16),
//                 itemCount: emailViewModel.length,
//                 itemBuilder: (context, index) {
//                   final message = emailViewModel[index];
//                   final isUserMessage = message.request.mainIdea.isNotEmpty;
//
//                   return Column(
//                     children: [
//                       _UserMessage(content: message.request.email),
//                       if (message.responses.isNotEmpty)
//                         _AIResponse(
//                           message: message,
//                           requestIndex: index,
//                           viewModelNotifier: viewModelNotifier,
//                         ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//             const _QuickActionButtons(),
//             _ChatInputWidget(viewModelNotifier: viewModelNotifier),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _UserMessage extends StatelessWidget {
//   final String content;
//
//   const _UserMessage({required this.content});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF0F5F9),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Text(
//         content,
//         style: const TextStyle(fontSize: 16, color: Colors.black),
//       ),
//     );
//   }
// }
//
// class _AIResponse extends StatelessWidget {
//   final ConversationMessage message;
//   final int requestIndex;
//   final EmailViewModel viewModelNotifier;
//
//   const _AIResponse({
//     required this.message,
//     required this.requestIndex,
//     required this.viewModelNotifier,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final response = message.responses[message.currentResponseIndex];
//
//     return Container(
//       padding: const EdgeInsets.all(16),
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'AI Reply',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF0087DF),
//             ),
//           ),
//           const Divider(color: Color(0xFFe4e4e4)),
//           const SizedBox(height: 8),
//           Text(response, style: const TextStyle(fontSize: 16)),
//           const SizedBox(height: 16),
//           const Divider(color: Color(0xFFe4e4e4)),
//           _ResponseActions(
//               viewModelNotifier: viewModelNotifier, requestIndex: requestIndex),
//         ],
//       ),
//     );
//   }
// }
//
// class _ResponseActions extends StatelessWidget {
//   final EmailViewModel viewModelNotifier;
//   final int requestIndex;
//
//   const _ResponseActions({
//     required this.viewModelNotifier,
//     required this.requestIndex,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         IconButton(
//           icon: const Icon(Icons.content_copy, color: Colors.grey),
//           onPressed: () {
//             Clipboard.setData(ClipboardData(
//                 text: viewModelNotifier.state[requestIndex].responses.last));
//             ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Response copied to clipboard')));
//           },
//         ),
//         IconButton(
//           icon: const Icon(Icons.refresh, color: Colors.grey),
//           onPressed: () => viewModelNotifier.refreshResponse(requestIndex),
//         ),
//         IconButton(
//           icon: Icon(
//             CupertinoIcons.arrowshape_turn_up_left_fill,
//             color: viewModelNotifier.canNavigateBack(requestIndex)
//                 ? Colors.blue // Enabled color
//                 : Colors.grey, // Disabled color
//           ),
//           onPressed: viewModelNotifier.canNavigateBack(requestIndex)
//               ? () => viewModelNotifier.navigateResponse(requestIndex, false)
//               : null,
//         ),
//         IconButton(
//           icon: Icon(
//             CupertinoIcons.arrowshape_turn_up_right_fill,
//             color: viewModelNotifier.canNavigateForward(requestIndex)
//                 ? Colors.blue // Enabled color
//                 : Colors.grey, // Disabled color
//           ),
//           onPressed: viewModelNotifier.canNavigateForward(requestIndex)
//               ? () => viewModelNotifier.navigateResponse(requestIndex, true)
//               : null,
//         ),
//       ],
//     );
//   }
// }
//
// class _QuickActionButtons extends ConsumerWidget {
//   const _QuickActionButtons({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final viewModelNotifier = ref.watch(emailViewModelProvider.notifier);
//     final selectedAction = ref.watch(
//         emailViewModelProvider.notifier.select((vm) => vm.selectedAction));
//
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: _buildQuickActionButton(
//                   '🙏 Thanks',
//                   viewModelNotifier,
//                   selectedAction,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: _buildQuickActionButton(
//                   '😔 Sorry',
//                   viewModelNotifier,
//                   selectedAction,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: _buildQuickActionButton(
//                   '👍 Yes',
//                   viewModelNotifier,
//                   selectedAction,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: _buildQuickActionButton(
//                   '👎 No',
//                   viewModelNotifier,
//                   selectedAction,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Row(
//             children: [
//               Expanded(
//                 flex: 2,
//                 child: _buildQuickActionButton(
//                   '📅 Follow up',
//                   viewModelNotifier,
//                   selectedAction,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 flex: 3,
//                 child: _buildQuickActionButton(
//                   '🤔 Request more info',
//                   viewModelNotifier,
//                   selectedAction,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildQuickActionButton(
//       String label, EmailViewModel viewModelNotifier, String? selectedAction) {
//     final isSelected = selectedAction == label;
//
//     return ElevatedButton(
//       onPressed: () => viewModelNotifier.selectAction(label),
//       style: ElevatedButton.styleFrom(
//         backgroundColor:
//             isSelected ? Colors.blue[100] : const Color(0xFFF0F5F9),
//         foregroundColor: isSelected ? Colors.blue : Colors.black,
//         elevation: 0,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
//       ),
//       child: FittedBox(
//         fit: BoxFit.scaleDown,
//         child: Text(
//           label,
//           style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }
// }
//
// class _ChatInputWidget extends StatelessWidget {
//   final EmailViewModel viewModelNotifier;
//
//   const _ChatInputWidget({required this.viewModelNotifier});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.grey[200],
//           borderRadius: BorderRadius.circular(25),
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: TextField(
//                 controller: viewModelNotifier.inputController,
//                 decoration: const InputDecoration(
//                   hintText: 'Type your message...',
//                   border: InputBorder.none,
//                   contentPadding: EdgeInsets.symmetric(horizontal: 16),
//                 ),
//               ),
//             ),
//             IconButton(
//               icon: const Icon(Icons.send, color: Colors.blue),
//               onPressed: () => viewModelNotifier.sendEmail(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
