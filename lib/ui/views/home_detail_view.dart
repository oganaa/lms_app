import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lms_app/models/categories_model.dart';

class HomeDetailView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Category", style: TextStyle(
              fontSize: 20,
              color: Color(0xFF0D1333),
              fontWeight: FontWeight.bold,
            )),
            Text(
              "See All",
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF6E8AFA),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 30),
        Container(
          height: 500,
          width: MediaQuery.of(context).size.width,
          child: StaggeredGridView.countBuilder(
            padding: EdgeInsets.all(0),
            crossAxisCount: 2,
            itemCount: listItems.length,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.all(20),
                height: index.isEven ? 200 : 240,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: AssetImage("assets/images/" +listItems[index].img),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      listItems[index].name,
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFFffffff),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${listItems[index].courses} Courses',
                      style: TextStyle(
                        color: Color(0xFFffffff),
                      ),
                    )
                  ],
                ),
              );
            },
            staggeredTileBuilder: (index) => StaggeredTile.fit(1),
          ),
        ),
      ],
    );
  }

}