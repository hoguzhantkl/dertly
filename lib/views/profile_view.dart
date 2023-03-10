import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:dertly/core/themes/custom_colors.dart';
import 'package:dertly/view_models/auth_viewmodel.dart';
import 'package:dertly/views/widgets/audiowave.dart';
import 'package:dertly/views/widgets/profile/entrieslist.dart';
import 'package:dertly/views/widgets/user/userimage.dart';
import 'package:dertly/views/widgets/user/userinformations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../repositories/user_repository.dart';
import '../view_models/user_viewmodel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.userID = ""});

  final String userID;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;

  late UserViewModel viewModel;

  bool isMyProfile = false;

  @override
  void initState() {
    viewModel = (widget.userID == "")
        ? Provider.of<UserViewModel>(context, listen: false)
        : UserViewModel(userRepository: UserRepository(), userModel: UserModel(userID: widget.userID));

    isMyProfile = (widget.userID == "");

    tabController = TabController(vsync: this, length: 4);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthViewModel authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    debugPrint("profile_view, building profile screen for userID: ${widget.userID}");
    return FutureBuilder(
      future: viewModel.fetchUserData(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

        if (snapshot.connectionState == ConnectionState.done) {
          return RefreshIndicator(
              onRefresh: () => Future.sync(() => setState(() {})),
              child: Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: NestedScrollView(
                    floatHeaderSlivers: true,
                    headerSliverBuilder: (context, builder){
                      return [
                        SliverToBoxAdapter(
                            child: Column(
                              children: [
                                Visibility(
                                  visible: !isMyProfile,
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        IconButton(
                                            onPressed: (){},
                                            icon: const Icon(Icons.arrow_back_rounded, size: 28),
                                            padding: const EdgeInsets.all(0)
                                        ),

                                        IconButton(
                                            onPressed: (){},
                                            icon: const Icon(Icons.more_vert_rounded, size: 26)
                                        ),
                                      ]
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
                                  child: Column(
                                      children: [
                                        // Top User Informations
                                        Row(
                                            children: [
                                              // User Image
                                              viewModel.getUserImage(width: 100, height: 100),

                                              const SizedBox(width: 12),

                                              // User Informations
                                              const Expanded(
                                                  child: UserInformations()
                                              ),
                                            ]
                                        ),

                                        const SizedBox(height: 12),

                                        // Username Audio
                                        Row(
                                          children: [
                                            Expanded(
                                              child: AudioWave(
                                                width: 320,
                                                playerController: PlayerController(),
                                                audioDuration: 2,
                                                audioWaveData: const [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,],
                                                showDuration: false,
                                                //audioWaveData: model.audioWaveData!,
                                                //audioDuration: model.audioDuration,
                                              ),
                                            ),

                                            // Play Button
                                            IconButton(
                                                onPressed: () async{},
                                                padding: const EdgeInsets.all(0),
                                                iconSize: 36,
                                                icon: Icon(Icons.play_arrow, size: 36)
                                            )
                                          ],
                                        ),

                                        // Buttons
                                        Flex(
                                          direction: Axis.horizontal,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Flexible(
                                                flex: 3,
                                                child: ButtonTheme(
                                                  minWidth: double.infinity,
                                                  height: 40,
                                                  child: MaterialButton(
                                                    padding: const EdgeInsets.all(0),
                                                    onPressed: (){},
                                                    child: Icon(Icons.person_add_rounded, size: 28),
                                                    textColor: CustomColors.beige,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(6),
                                                        side: BorderSide(color: Colors.white10, width: 2)
                                                    ),
                                                  ),
                                                )
                                            ),

                                            const SizedBox(width: 12),

                                            Flexible(
                                                flex: 3,
                                                child: ButtonTheme(
                                                  minWidth: double.infinity,
                                                  height: 40,
                                                  child: MaterialButton(
                                                    padding: const EdgeInsets.all(0),
                                                    onPressed: (){},
                                                    child: Icon(Icons.mic_rounded, size: 28),
                                                    textColor: CustomColors.beige,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(6),
                                                        side: BorderSide(color: Colors.white10, width: 2)
                                                    ),
                                                  ),
                                                )
                                            ),

                                            const SizedBox(width: 12),

                                            Flexible(
                                                flex: 1,
                                                child: ButtonTheme(
                                                  minWidth: double.infinity,
                                                  height: 40,
                                                  child: MaterialButton(
                                                    padding: const EdgeInsets.all(0),
                                                    onPressed: (){},
                                                    child: Icon(Icons.keyboard_arrow_down_rounded, size: 28),
                                                    textColor: CustomColors.beige,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(6),
                                                        side: BorderSide(color: Colors.white10, width: 2)
                                                    ),
                                                  ),
                                                )
                                            ),
                                          ],
                                        ),
                                      ]
                                  ),
                                )
                              ],
                            )
                        ),

                        SliverPersistentHeader(
                          delegate: MyDelegate(
                            TabBar(
                              tabs: const [
                                Tab(text: 'Entries'),
                                Tab(text: 'Answers'),
                                Tab(text: 'Votes'),
                                Tab(text: 'Achievements'),
                              ],
                              indicatorColor: Theme.of(context).indicatorColor,
                              indicatorPadding: const EdgeInsets.only(bottom: 4.0),
                              controller: tabController,
                            ),
                          ),
                          //floating: true,
                          pinned: true,
                        ),
                      ];
                    },
                    // Entries, Answers, ...
                    body: TabBarView(
                      controller: tabController,
                      children: <Widget>[
                        ProfileEntriesList(userID: authViewModel.getUserID()),
                        Center(child: Text('Answers')),
                        Center(child: Text('Votes')),
                        Center(child: Text('Achievements')),
                      ],
                    )
                  )
              )
          );
        }

        return const SizedBox();
      },
      //catchError: (context, error) {debugPrint("profile_view, error while fetching userData provider: $error");},
      initialData: viewModel,
      //child:
    );
  }
}

class MyDelegate extends SliverPersistentHeaderDelegate {
  MyDelegate(this.tabBar);
  final TabBar tabBar;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return tabBar;
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
