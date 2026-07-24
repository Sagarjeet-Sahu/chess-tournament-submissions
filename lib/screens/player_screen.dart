import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/player.dart';
import '../providers/player_provider.dart';

class PlayerScreen extends ConsumerStatefulWidget{
  const PlayerScreen({super.key});

  @override
  ConsumerState<PlayerScreen> createState()=> _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen>{
  final nameController=TextEditingController();
  final ageController=TextEditingController();
  final ratingController=TextEditingController();
  bool isEditing=false;
  int? editingId;

  @override
  void dispose(){
    nameController.dispose();
    ageController.dispose();
    ratingController.dispose();
    super.dispose();
  }

  void clearFields(){
    nameController.clear();
    ageController.clear();
    ratingController.clear();

    editingId=null;
    isEditing=false;  
  }
  @override
  Widget build(BuildContext context) {
    final players=ref.watch(playerProvider);

    return Scaffold(
      appBar: AppBar(
        title:const Text("Players"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Player Name",
                border: OutlineInputBorder(),
              ),
            ),
            
            const SizedBox(height:10),

            TextField(
              controller:ageController,
              keyboardType:TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Age",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height:10),

            TextField( 
              controller: ratingController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Rating",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width:double.infinity,
              child: ElevatedButton(
                child: Text(isEditing ? "update Player" : "Add Player"),
                onPressed: () async {
             
                  if(nameController.text.isEmpty || 
                  ageController.text.isEmpty || 
                  ratingController.text.isEmpty){
                    return;
                  }

                  final player=Player(
                    id: editingId,
                    name: nameController.text,
                    age: int.parse(ageController.text),
                    rating: int.parse(ratingController.text),
                  );

                  if(isEditing){
                    await ref.read(playerProvider.notifier).updatePlayer(player);
                  }else{
                    await ref.read(playerProvider.notifier).addPlayer(player);
                  }

                  clearFields();
                },
                ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: players.isEmpty
              ? const Center(
                child: Text("No Players Added"),
                )
            : ListView.builder(
          itemCount:players.length,
          itemBuilder: (context,index){

            final player= players[index];

            return Card(
              child: ListTile(
                title: Text(player.name),
                subtitle: Text(
                  "Age: ${player.age} | Rating: ${player.rating}",
                ),

                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children:[

                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed:(){
                        nameController.text=player.name;
                        ageController.text=player.age.toString();
                        ratingController.text=player.rating.toString();
                        editingId=player.id;
                        isEditing=true;

                        setState((){});
                      },
                    ),

                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await ref.read(playerProvider.notifier).deletePlayer(player.id!);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
         ),
        ),
       ],
      ),
    ),
    );
  }
}
