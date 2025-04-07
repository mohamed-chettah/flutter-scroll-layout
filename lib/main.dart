import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class Dish {
  final String name;
  final String image;
  final double price;
  final String description;

  Dish({
    required this.name,
    required this.image,
    required this.price,
    required this.description,
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menu du Restaurant',
      home: MenuScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final List<String> categories = ['Entrées', 'Plats', 'Desserts'];
  int selectedIndex = 0;

  final PageController _pageController = PageController();
  final ScrollController _categoryScrollController = ScrollController();

  final Map<String, List<Dish>> dishesByCategory = {
    'Entrées': [
      Dish(
        name: 'Salade César',
        image: 'https://picsum.photos/seed/salade/200/200',
        price: 6.50,
        description: 'Salade, poulet, parmesan, croûtons.',
      ),
      Dish(
        name: 'Soupe à l\'oignon',
        image: 'https://picsum.photos/seed/soupe/200/200',
        price: 5.00,
        description: 'Soupe gratinée traditionnelle.',
      ),
    ],
    'Plats': [
      Dish(
        name: 'Steak Frites',
        image: 'https://picsum.photos/seed/steak/200/200',
        price: 12.90,
        description: 'Steak de bœuf grillé, frites maison.',
      ),
      Dish(
        name: 'Poulet curry',
        image: 'https://picsum.photos/seed/curry/200/200',
        price: 11.50,
        description: 'Poulet tendre dans une sauce curry épicée.',
      ),
    ],
    'Desserts': [
      Dish(
        name: 'Tarte aux pommes',
        image: 'https://picsum.photos/seed/tarte/200/200',
        price: 4.50,
        description: 'Tarte maison croustillante.',
      ),
      Dish(
        name: 'Mousse au chocolat',
        image: 'https://picsum.photos/seed/mousse/200/200',
        price: 4.00,
        description: 'Chocolat noir onctueux.',
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu du Restaurant'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          _buildCategorySelector(),
          SizedBox(height: 10),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final dishes = dishesByCategory[categories[index]]!;
                return ListView.builder(
                  itemCount: dishes.length,
                  itemBuilder: (context, i) {
                    return DishCard(dish: dishes[i]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        controller: _categoryScrollController,
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 10),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              _pageController.animateToPage(
                index,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              _categoryScrollController.animateTo(
                index * 120,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 250),
              margin: EdgeInsets.symmetric(horizontal: 5),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.deepPurple : Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.4),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ]
                    : [],
              ),
              child: Center(
                child: Text(
                  categories[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class DishCard extends StatelessWidget {
  final Dish dish;

  DishCard({required this.dish});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                dish.image,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dish.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '${dish.price.toStringAsFixed(2)} €',
                    style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                  SizedBox(height: 5),
                  Text(
                    dish.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
