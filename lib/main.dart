import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey[300],
        appBar:MediaQuery.of(context).size.width<900? AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: GestureDetector(
              onTap: () {
                _scaffoldKey.currentState!.openDrawer();
              },
              child: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
            ),
            onPressed: () {},
          ),
        ):null,
        drawer: Drawer(
          child: Column(
            children: [
              const DrawerHeader(
                child: Icon(
                  Icons.heart_broken_sharp,
                  size: 100,
                  color: Colors.white,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title:  Text('Home',style: TextStyle(
                  fontSize: getResponsiveFontSize(20, context)
                ),),
                onTap: () {},
              ),
            ],
          ),
        ),
        body: const BetterExample(),
      ),
    );
  }
}

//1-caculate scale factor (width of platform)
//2-responsive font size using scale factor
//3- (min and max) between for font size
//to caculate the scale factor for every platform i take min and max of breakpoints of the platform
//for example mobile has break point from 0 to 600 so i will take min so i will choose 400
//tablet 600 to 900 so i will choose 700
//desktop 900 < so i will choose 1000
//scale factor = width of platform / size of platform
//responsive font size = scale factor * font size
double getResponsiveFontSize(double fontSize,context)
{
  double scaleFactor= getScaleFactor(context);
  double responsiveFontSize=fontSize*scaleFactor;
  double lowerLimit=fontSize*0.8;
  double upperLimit=fontSize*1.2;
  return responsiveFontSize.clamp(lowerLimit, upperLimit);
}

double getScaleFactor(context) {
  double width=MediaQuery.of(context).size.width;
  if(width<600)
  {
    return width/400;
  }else if(width<900)
  {
    return width/700;
  }else
  {
    return width/1000;
  }
}
class BetterExample extends StatelessWidget {
  const BetterExample({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context,constraints){
        if(constraints.maxWidth < 600) {
          return const MobileLayout();
        }else if(constraints.maxWidth<900)
        {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 20,
                  ),
                ),
                SliverToBoxAdapter(
                  child: LayoutBuilder(builder: (context, constraints) {
                    if (constraints.maxWidth >= 600) {
                      return SizedBox(
                        height: 200,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (context, index) =>
                          const AspectRatio(
                            aspectRatio: 1,
                            child: CircleContainer(),
                          ),
                          separatorBuilder: (context, index) =>
                          const SizedBox(
                            width: 20,
                          ),
                        ),
                      );
                    } else {
                      return const CustomSliverGrid();
                    }
                  }),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 20,
                  ),
                ),
                const CustomSliverList(),
              ],
            ),
          );
        }
        else
        {
          return const Text('Desktop Layout');
          //drawer
          //body(tablet layout)
          //two columns
        }
      }
    );
  }
}

class CustomSliverList extends StatelessWidget {
  const CustomSliverList({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemCount: 10,
      itemBuilder: (context, index) => Container(
        height: 100,
        decoration: const BoxDecoration(
          color: Colors.grey,
        ),
      ),
      separatorBuilder: (context, index) => const SizedBox(
        height: 20,
      ),
    );
  }
}

class CustomSliverGrid extends StatelessWidget {
  const CustomSliverGrid({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
      ),
      itemBuilder: (context, index) => const CircleContainer(),
    );
  }
}

//i make that cuz i will it maybe the grid setiings will be changed in tablet or mobile screen
class CircleContainer extends StatelessWidget {
  const CircleContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

// LayoutBuilder(builder: (context, constraints) {
//       //   if(constraints.maxWidth <= 500){
//       //     return const MobileLayout();
//       //   }else
//       //   {
//       //     return const Text('Tablet Layout');
//       //   }
//       // }),
class MobileLayout extends StatelessWidget {
  const MobileLayout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //here i have issue that i with width when i stretch the screen
    //it will not change the width of the container
    //so here i will use LayoutBuilder to solve this issue
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          color: Colors.green,
          margin: const EdgeInsets.all(10),
          child: ListTile(
            title: Text('Item ${index + 1}'),
          ),
        );
      },
    );
  }
}

class MediaQueries extends StatelessWidget {
  const MediaQueries({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Column(
      children: <Widget>[
        Container(
          height: height * 0.3,
          width: 100,
          color: Colors.red,
        ),
        Container(
          height: height * 0.3,
          width: 100,
          color: Colors.blue,
        ),
        Container(
          height: height * 0.3,
          width: 100,
          color: Colors.green,
        ),
      ],
    );
  }
}

class FLexibleWidgets extends StatelessWidget {
  const FLexibleWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Flexible(
          child: FittedBox(
            child: Icon(
              CupertinoIcons.snow,
              size: 400,
            ),
          ),
        ),
        Container(
          height: 150,
          color: Colors.blue,
        ),
        Container(
          height: 150,
          color: Colors.red,
        ),
        Container(
          height: 150,
          color: Colors.green,
        ),
      ],
    );
  }
}

class IntrisicWidgets extends StatelessWidget {
  const IntrisicWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        IntrinsicHeight(
          child: Row(
            children: <Widget>[
              Container(
                width: 100,
                color: Colors.red,
              ),
              Container(
                width: 100,
                color: Colors.blue,
              ),
              Container(
                width: 100,
                color: Colors.green,
              ),
            ],
          ),
        ),
        Row(
          children: <Widget>[
            Container(
              width: 100,
              color: Colors.red,
            ),
            Container(
              width: 100,
              color: Colors.blue,
            ),
            Container(
              width: 100,
              color: Colors.green,
            ),
          ],
        ),
        Container(
          height: 150,
          color: Colors.blue,
        ),
        Container(
          height: 150,
          color: Colors.red,
        ),
        Container(
          height: 150,
          color: Colors.green,
        ),
      ],
    );
  }
}

class FullExample extends StatelessWidget {
  const FullExample({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                ),
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                  ),
                ),
                itemCount: 4,
              ),
            ),
            ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  height: 10,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
