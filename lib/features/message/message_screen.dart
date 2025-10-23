// import 'package:flutter/material.dart';
// import 'package:banking_app/core/common/extensions/context_extensions.dart';
// import 'package:banking_app/core/widgets/layouts/app_bar.dart';
// import 'package:banking_app/core/widgets/layouts/scaffold.dart';
// import 'package:loader_overlay/loader_overlay.dart';

// /// Model for message items
// class MessageModel {
//   final String id;
//   final String title;
//   final String preview;
//   final String date;
//   final IconData icon;
//   final Color iconColor;
//   final Color iconBackground;

//   MessageModel({
//     required this.id,
//     required this.title,
//     required this.preview,
//     required this.date,
//     required this.icon,
//     required this.iconColor,
//     required this.iconBackground,
//   });
// }

// /// A screen that displays the list of messages (similar to Message #1)
// class MessageScreen extends StatelessWidget {
//   const MessageScreen({super.key});

//   /// Sample messages data
//   List<MessageModel> _getMessages() {
//     return [
//       MessageModel(
//         id: '1',
//         title: 'Bank of America',
//         preview: 'Bank of America : 256486 is the au...',
//         date: 'Today',
//         icon: Icons.account_balance,
//         iconColor: Colors.white,
//         iconBackground: const Color(0xFF5B4CCC),
//       ),
//       MessageModel(
//         id: '2',
//         title: 'Account',
//         preview: 'Your account is limited. Please foll...',
//         date: '12/10',
//         icon: Icons.person,
//         iconColor: Colors.white,
//         iconBackground: const Color(0xFFFF6B9D),
//       ),
//       MessageModel(
//         id: '3',
//         title: 'Alert',
//         preview: 'Your statement is ready for you to...',
//         date: '11/10',
//         icon: Icons.insert_drive_file_outlined,
//         iconColor: Colors.white,
//         iconBackground: const Color(0xFF4E9FFF),
//       ),
//       MessageModel(
//         id: '4',
//         title: 'Paypal',
//         preview: 'Your account has been locked. Ple...',
//         date: '10/11',
//         icon: Icons.payment,
//         iconColor: Colors.white,
//         iconBackground: const Color(0xFFFFAB2E),
//       ),
//       MessageModel(
//         id: '5',
//         title: 'Withdraw',
//         preview: 'Dear customer, 2987456 is your co...',
//         date: '10/12',
//         icon: Icons.account_balance_wallet,
//         iconColor: Colors.white,
//         iconBackground: const Color(0xFF4ECAC3),
//       ),
//     ];
//   }

//   /// Navigates to the message detail screen
//   void _navigateToMessageDetail(BuildContext context, MessageModel message) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => MessageDetailScreen(message: message),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LoaderOverlay(
//       child: BAScaffold(
//         appBar: BAAppBar(
//           title: 'Message',
//           titleColor: context.colorScheme.scrim,
//           alignment: BAAppBarAlignment.left,
//           iconColor: context.colorScheme.scrim,
//         ),
//         body: ListView.builder(
//           padding: const EdgeInsets.symmetric(vertical: 8),
//           itemCount: _getMessages().length,
//           itemBuilder: (context, index) {
//             final message = _getMessages()[index];
//             return MessageListItem(
//               message: message,
//               onTap: () => _navigateToMessageDetail(context, message),
//             );
//           },
//         ),
//         bottomNavigationBar: _buildBottomNavBar(context),
//       ),
//     );
//   }

//   Widget _buildBottomNavBar(BuildContext context) {
//     return Container(
//       height: 80,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, -5),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildNavItem(Icons.home_outlined, false),
//           _buildNavItem(Icons.search, false),
//           _buildNavItem(Icons.message, true, label: 'Message'),
//           _buildNavItem(Icons.settings_outlined, false),
//         ],
//       ),
//     );
//   }

//   Widget _buildNavItem(IconData icon, bool isActive, {String? label}) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         if (label != null)
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
//             decoration: BoxDecoration(
//               color: const Color(0xFF5B4CCC),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(
//                   icon,
//                   color: Colors.white,
//                   size: 20,
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   label,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           )
//         else
//           Icon(
//             icon,
//             color: isActive ? const Color(0xFF5B4CCC) : Colors.grey,
//             size: 24,
//           ),
//       ],
//     );
//   }
// }

// /// Widget for individual message list item
// class MessageListItem extends StatelessWidget {
//   final MessageModel message;
//   final VoidCallback onTap;

//   const MessageListItem({
//     super.key,
//     required this.message,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//         child: Row(
//           children: [
//             Container(
//               width: 48,
//               height: 48,
//               decoration: BoxDecoration(
//                 color: message.iconBackground,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(
//                 message.icon,
//                 color: message.iconColor,
//                 size: 24,
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     message.title,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     message.preview,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey[600],
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 12),
//             Text(
//               message.date,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey[500],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// Message detail screen (similar to Message #2 and #3)
// class MessageDetailScreen extends StatefulWidget {
//   final MessageModel message;

//   const MessageDetailScreen({super.key, required this.message});

//   @override
//   State<MessageDetailScreen> createState() => _MessageDetailScreenState();
// }

// class _MessageDetailScreenState extends State<MessageDetailScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final List<ChatMessage> _messages = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadInitialMessages();
//   }

//   void _loadInitialMessages() {
//     // Simulate Bank of America conversation
//     _messages.addAll([
//       ChatMessage(
//         text: 'Did you attempt transaction on debit card ending in 0000 at Mechani in NJ for \$1,200?\nReply YES or NO',
//         isFromUser: false,
//         timestamp: '8/10/2018',
//       ),
//       ChatMessage(
//         text: 'Yes',
//         isFromUser: true,
//         timestamp: '8/10/2018',
//       ),
//       ChatMessage(
//         text: 'Bank of America : 256486 is your authorization code which expires in 10 minutes. If you didn\'t request the code.\nCall : 18009898 for assistance',
//         isFromUser: false,
//         timestamp: '8/10/2018',
//       ),
//       ChatMessage(
//         text: 'Thanks!',
//         isFromUser: true,
//         timestamp: '8/10/2018',
//       ),
//     ]);
//   }

//   void _sendMessage() {
//     if (_messageController.text.trim().isEmpty) return;

//     setState(() {
//       _messages.add(ChatMessage(
//         text: _messageController.text,
//         isFromUser: true,
//         timestamp: '8/10/2018',
//       ));
//       _messageController.clear();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BAScaffold(
//       appBar: BAAppBar(
//         title: widget.message.title,
//         // subtitle: widget.message.title == 'Bank of America'
//         //     ? 'Mechani in NJ for \$1,200?\nReply YES or NO'
//         //     : null,
//         titleColor: context.colorScheme.scrim,
//         alignment: BAAppBarAlignment.left,
//         iconColor: context.colorScheme.scrim,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final message = _messages[index];
//                 return ChatBubble(message: message);
//               },
//             ),
//           ),
//           _buildMessageInput(context),
//         ],
//       ),
//     );
//   }

//   Widget _buildMessageInput(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, -5),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         child: Row(
//           children: [
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[100],
//                   borderRadius: BorderRadius.circular(24),
//                 ),
//                 child: TextField(
//                   controller: _messageController,
//                   decoration: const InputDecoration(
//                     hintText: 'Type something...',
//                     border: InputBorder.none,
//                   ),
//                   onSubmitted: (_) => _sendMessage(),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 8),
//             Container(
//               width: 48,
//               height: 48,
//               decoration: const BoxDecoration(
//                 color: Color(0xFF5B4CCC),
//                 shape: BoxShape.circle,
//               ),
//               child: IconButton(
//                 icon: const Icon(Icons.send, color: Colors.white, size: 20),
//                 onPressed: _sendMessage,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _messageController.dispose();
//     super.dispose();
//   }
// }

// /// Model for chat messages
// class ChatMessage {
//   final String text;
//   final bool isFromUser;
//   final String timestamp;

//   ChatMessage({
//     required this.text,
//     required this.isFromUser,
//     required this.timestamp,
//   });
// }

// /// Widget for chat bubble
// class ChatBubble extends StatelessWidget {
//   final ChatMessage message;

//   const ChatBubble({super.key, required this.message});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Column(
//         crossAxisAlignment: message.isFromUser
//             ? CrossAxisAlignment.end
//             : CrossAxisAlignment.start,
//         children: [
//           Container(
//             constraints: BoxConstraints(
//               maxWidth: MediaQuery.of(context).size.width * 0.7,
//             ),
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             decoration: BoxDecoration(
//               color: message.isFromUser
//                   ? const Color(0xFF5B4CCC)
//                   : Colors.grey[100],
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Text(
//               message.text,
//               style: TextStyle(
//                 color: message.isFromUser ? Colors.white : Colors.black87,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//           const SizedBox(height: 4),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 4),
//             child: Text(
//               message.timestamp,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey[500],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }