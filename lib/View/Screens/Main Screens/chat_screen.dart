import 'package:barter_system/linker.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: CustomText(text: "Messages", size: 16, weight: FontWeight.w500),
      ),
      body: StreamBuilder(
        stream: AuthService.getMyUsersId(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(child: CircularProgressIndicator());

            case ConnectionState.active:
            case ConnectionState.done:
              final userIds =
                  snapshot.data?.docs.map((e) => e.id).toList() ?? [];
              print('User IDs: ${userIds.join(', ')}');
              if (userIds.isEmpty) {
                return const Center(
                    child: Text('No Chats Found!',
                        style: TextStyle(fontSize: 20)));
              }

              return StreamBuilder(
                stream: AuthService.getMessagedUser(userIds),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(child: CircularProgressIndicator());

                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;
                      final list = data
                              ?.map((e) => UserModel.fromJson(e.data()))
                              .toList() ??
                          [];

                      if (list.isNotEmpty) {
                        return ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            print(list[index].id);
                            print(list[index].userName);
                            print(list[index].profilePic);
                            return ChatTile(id: list[index].id, name: list[index].userName, pic: list[index].profilePic, about: list[index].about);
                          },
                        );
                      } else {
                        return const Center(
                          child: Text('No Chats Found!',
                              style: TextStyle(fontSize: 20)),
                        );
                      }
                  }
                },
              );
          }
        },
      ),
    );
  }
}
