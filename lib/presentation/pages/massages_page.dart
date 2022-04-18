import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instegram/presentation/cubit/firestoreUserInfoCubit/users_info_cubit.dart';
import 'package:instegram/presentation/widgets/toast_show.dart';

class MassagesPage extends StatelessWidget {
  final String userId;
 const MassagesPage({Key? key,required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        // title: ,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.add,
                size: 30,
              ))
        ],
      ),

      body: BlocBuilder<UsersInfoCubit,UsersInfoState>(
        // bloc:UsersInfoCubit.get(context)..getSpecificUsersInfo(usersIds: usersIds) ,
       builder: (context, state) {
         if(state is CubitGettingSpecificUsersLoaded){
           return ListView.separated(
               itemBuilder: (context, index) {
                 return ListTile(
                   title: const Text("The Name"),
                   leading: const CircleAvatar(
                       child: Icon(Icons.person, color: Colors.white, size: 50),
                       radius: 30),
                   onTap: () {

                   },
                 );
               },
               itemCount: 5,
               separatorBuilder: (BuildContext context, int index) =>
               const Divider());
         }else if(state is CubitGettingSpecificUsersFailed){
           ToastShow.toastStateError(state);
           return const Text("Something Wrong");
         } else {
           return const Center(
             child: CircularProgressIndicator(
                 strokeWidth: 1, color: Colors.black54),
           );
         }

       },
      ),
    );
  }
}
