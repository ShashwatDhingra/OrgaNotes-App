import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:organotes/ui/resuables/my_text_button.dart';
import 'package:organotes/ui/resuables/note_tile.dart';
import 'package:organotes/ui/view_model/home_view_model.dart';
import 'package:organotes/utils/routes/routes.dart';
import 'package:organotes/utils/screen_size.dart';
import 'package:organotes/utils/utils.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key, this.isPreviousLoginScreen = false});

  bool isPreviousLoginScreen;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final scHeight = ScreenSize.screenHeight;

  final scWidth = ScreenSize.screenWidth;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final homeViewMode = Provider.of<HomeViewModel>(context, listen: false);
      homeViewMode.getNotes();
      await homeViewMode.getUserData();
      if (widget.isPreviousLoginScreen) {
        homeViewMode.checkNotes('shashwatdhingra2@gmail.com', context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<HomeViewModel>(
          builder: (context, value, child) => CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    floating: true,
                    snap: true,
                    expandedHeight: scHeight * 0.2,
                    backgroundColor: Colors.grey,
                    flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.parallax,
                        background: Opacity(
                            opacity: 0.2,
                            child: Image.asset('assets/images/notes_bg.jpg',
                                fit: BoxFit.fill)),
                        centerTitle: true,
                        title: const Text('M Y  N O T E S')),
                  ),
                  SliverList(
                      delegate: value.notes.isEmpty
                          ? SliverChildListDelegate([
                              (scHeight * 0.4).ph,
                              const Center(
                                  child: Text(
                                'Empty',
                                style: TextStyle(color: Colors.grey),
                              ))
                            ])
                          : SliverChildBuilderDelegate(
                              childCount: value.notes.length,
                              (context, index) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, Routes.noteEditView,
                                          arguments: {
                                            "isEditing": true,
                                            "note": value.notes[index]
                                          });
                                    },
                                    child: NoteTile(
                                      note: value.notes[index],
                                      deleteNote: (noteId) {
                                        value.deleteNote(noteId);
                                      },
                                    ));
                              },
                            )),
                ],
              )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white70,
        onPressed: () {
          Navigator.pushNamed(context, Routes.noteEditView,
              arguments: {"isEditing": false, "note": null});
        },
        child: const Icon(Icons.add, size: 24, color: Colors.black),
      ),
      drawer: Drawer(
          child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Consumer<HomeViewModel>(
                builder: (context, value, child) => Column(children: [
                      UserAccountsDrawerHeader(
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(12)),
                          currentAccountPicture: CircleAvatar(
                              backgroundColor: Colors.grey.shade300,
                              child: const Icon(Icons.person,
                                  color: Colors.grey, size: 42)),
                          accountName: Text(value.userName),
                          accountEmail: Text(value.userMail)),
                      ListTile(
                          title: Text('Automatic backup',
                              style: TextStyle(fontSize: 16)),
                          trailing: Switch(
                            value: value.isBackupEnabled,
                            onChanged: (newValue) {
                              value.changeBackupOptionValue(newValue);
                            },
                          )),
                    ])),
            ListTile(
              title: const Text('Import Notes'),
              onTap: () {
                Navigator.pop(context);
                final homeViewModel = context.read<
                    HomeViewModel>(); // This means Provider.of<HomeViewModel>(context, listen:false)
                homeViewModel.checkNotes(homeViewModel.userMail, context);
              },
            ),
            ListTile(
                title: const Text('Logout'),
                leading: const Icon(Icons.logout),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: const Text(
                            'Alert: Notes will be deleted if not backed-up. ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        actions: [
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Consumer<HomeViewModel>(
                                builder: (context, value, child) =>
                                    MyTextButton(
                                  text: 'No',
                                  onPress: value.loading
                                      ? () {}
                                      : () {
                                          Navigator.pop(context);
                                        },
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Consumer<HomeViewModel>(
                              builder: (context, value, child) => value.loading
                                  ? SpinKitFadingCircle(color: Colors.black)
                                  : MyTextButton(
                                      text: 'Yes',
                                      onPress: () async {
                                        final val =
                                            await Provider.of<HomeViewModel>(
                                                    context,
                                                    listen: false)
                                                .logout();
                                        if (val) {
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              Routes.introView,
                                              (route) => false);
                                        } else {
                                          Utils.showToast(
                                              'Please try again later !',
                                              true,
                                              context);
                                        }
                                      },
                                    ),
                            ),
                          )
                        ],
                        title: const Text('Logout'),
                      );
                    },
                  );
                }),
          ],
        ),
      )),
    );
  }
}
