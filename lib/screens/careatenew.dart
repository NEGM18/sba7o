import 'package:flutter/material.dart';
import 'package:sba7o/gamescreeen.dart/bank.dart';
import 'package:sba7o/gamescreeen.dart/bingo.dart';
import 'package:sba7o/gamescreeen.dart/nso7ygame.dart';
import 'package:sba7o/gamescreeen.dart/oofside.dart';
import 'package:sba7o/gamescreeen.dart/passwod.dart';
import 'package:sba7o/gamescreeen.dart/risk.dart';
import 'package:sba7o/gamescreeen.dart/top10.dart';
import 'package:sba7o/gamescreeen.dart/whoisinimage.dart';
import 'package:sba7o/gamescreeen.dart/whoistheplayer.dart';
import 'package:sba7o/services/audio_video_service.dart';
import 'package:video_player/video_player.dart';

class Careatenew extends StatefulWidget {
  const Careatenew({super.key});

  @override
  State<Careatenew> createState() => _CareatenewState();
}

class _CareatenewState extends State<Careatenew>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final AudioVideoService _audioVideoService = AudioVideoService();

  // List of game categories with their titles and descriptions.
  final List<Map<String, String>> categories = [
    {
      'title': 'offside',
      'desc': 'يقوم الحكم بسؤال الفريقين عن اسم (لاعب/مدرب .. الخ) ذو مواصفات خاصة (مثال: اشول و اسباني)\nعلى كل الأعضاء كتابة اسم تقع عليه تلك المواصفات خلال 10 ثواني\nيتم اهداء نقطة لفريق كل لاعب كتب اسم صحيح\nاذا وجد أكثر من عضو كتب نفس الاسم لا يحصلون على نقاط (حتى لو من نفس الفريق)'
    },
    {
      'title': 'bingo',
      'desc': 'يتم عرض 12 لاعب للفريقين\nالفائز بـ(طوبة ورقة مقص) يختار الفريق الذي سيجاوب أولاً\nيبدأ الحكم بسؤال مقارنة بين الـ12 لاعب (من هو أطول لاعب)\nفي حالة الإجابة الصحيحة، يُشطب اللاعب من القائمة و ينتقل السؤال للفريق الآخر\nفي حالة إجابة خاطئة، ينتقل الدور للفريق الآخر\nتستمر اللعبة حتى يتبقى لاعب واحد فقط ثم يسأل الحكم سؤال عنه (مثلاً: في أي عام فاز بدوري الأبطال)\nبعد شطب الـ12 لاعب، الفريق صاحب أقل عدد من الإجابات الخاطئة يفوز'
    },
    {
      'title': '#توب 10',
      'desc': 'يتم عرض جدول من ترتيب فرق/لاعبين (TOP 10 GOALSCORERS) IN UCL\nيتناوب الأعضاء الإجابة بنظام ABAB\nالإجابة على الترتيب العاشر = 10 نقاط و الأول = نقطة واحدة\nقد يكون هناك بعد الخانات الظاهرة اذا كانت الإجابة مستحيلة من وجهة نظر الحكم\nيستطيع الحكم أن يعطي 3 أدلة (كلو) لآخر عضو جاوب إجابة صحيحة عندما يخطئ الجميع في الإجابة مرتين متتاليتين'
    },
    {
      'title': '#كلمة السر',
      'desc': 'ممنوع ذكر اسم أي لاعب او فريق او جنسية او رقم\nيجب ذكر كلمة واحدة فقط في كل مرة و يتم لعب 8 جولات\nمتاح 30 ثانية لكل فريق لذكر الدليل و سماع الاجابة'
    },
    {
      'title': '#من X الصورة',
      'desc': 'يتم عرض صورة في بداية المباراة و يتم لعب 5 جولات\nيجب على كل لاعب تخمين اسم لاعب من 11 لاعب في دوره\nالفريق صاحب أكبر عدد من الإجابات الصحيحة يفوز بالجولة\nاذا جاوب لاعب اجابتين خاطئتين على التوالي يتم استبعاده من باقي الجولة'
    },
    {
      'title': '#بنك',
      'desc': 'اللعبة مكونة من 6 جولات، كل جولة 12 سؤال او 2 دقيقة\nيمكن للفريق قول (بنك) قبل اي سؤال لحفظ النقاط السابقة وحساب النقاط من جديد\nتسلسل النقاط 1 - 4 - 8 - 16'
    },
    {
      'title': '#من هو اللاعب',
      'desc': 'هناك 5 ادلة متاحة لكل لاعب و يتم لعب 3 جولات\nفي حالة تخمين اسم خاطئ تتحول افضلية الاجابة الى الفريق الآخر بعد سماع الدليل التالي'
    },
    {
      'title': "لعبه نصوحي",
      'desc': 'يقوم اعضاء الفريق بسحب ورقة بها كلمة عشوائية من الحكم\nيعد الحكم 1..2..3 ثم يقول كل عضو الكلمة التي سحبها في نفس الوقت (مثلاً لاعب او زوجية)\nيعد الحكم 1..2..3 ثم يقول كل عضو كلمة جديدة من خياله\nالهدف هو ان يقول عضوين الفريق نفس الكلمة (كتلة جيرارد)\nالفريق الذي يصل لنفس الكلمة في اقل عدد من المحاولات يفوز بالنقطة\nممنوع تكرار الكلمات'
    },
    {
      'title': 'risk',
      'desc': 'يختار الفريق السؤال من الاختيارات المتبقية و يربح نقاط السؤال في حالة الإجابة الصحيحة\nيفوز الفريق صاحب النقاط الأكثر بعد انتهاء جميع الأسئلة\nيوجد سؤال بضعف النقاط لا يعلمه المتسابقون\nيوجد وسائل مساعدة: الاتصال بصديق - اضافة وقت - اختيارات - الاجابة على سؤال الخصم في حالة عدم الاجابة'
    },
  ];

  // Map to hold the navigation routes for each category.
  // This makes it easy to manage which screen each card navigates to.
  // Initialized directly at class level to avoid LateInitializationError.
  final Map<String, WidgetBuilder> _routes = {
    'offside': (context) => const offside(),
    'bingo': (context) => const bingo(),
    '#توب 10': (context) => const top10(),
    '#كلمة السر': (context) => const password(),
    '#من X الصورة': (context) => const whoisinimage(),
    '#بنك': (context) => const bank(),
    '#من هو اللاعب': (context) => const whoistheplayer(),
    'لعبه نصوحي': (context) => const nso7ygame(),
    'risk': (context) => const Risk(),
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _initializeAudioVideo();
  }

  // Initializes audio and video services.
  Future<void> _initializeAudioVideo() async {
    await _audioVideoService.initializeAll();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      
      body: Stack(
        children: [
          // Display video background if initialized.
          if (_audioVideoService.isVideoInitialized && _audioVideoService.videoPlayerController != null)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _audioVideoService.videoPlayerController!.value.size.width,
                  height: _audioVideoService.videoPlayerController!.value.size.height,
                  child: VideoPlayer(_audioVideoService.videoPlayerController!),
                ),
              ),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text(
                        'اختر نوع اللعبة',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 4,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Display the count of categories (selection count is no longer relevant for this navigation method)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${categories.length} ألعاب متاحة', // Changed to show total available games
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        // Get the route for the current category title.
                        final WidgetBuilder? routeBuilder = _routes[cat['title']!];

                        return GestureDetector(
                          onTap: () {
                            // Only navigate if a route is defined for this category.
                            if (routeBuilder != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: routeBuilder),
                              );
                            } else {
                              // Optional: Show a message if no route is defined for a category.
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('No route defined for ${cat['title']!}'),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            }
                          },
                          child: Card(
                            // Card color is now static as selection is not maintained
                            color: Colors.white.withOpacity(0.92),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cat['title']!,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple, // Static color
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    cat['desc']!,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black87, // Static color
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
