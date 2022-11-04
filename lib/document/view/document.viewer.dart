import 'package:celebrated/appIntro/controller/intro.controller.dart';
import 'package:celebrated/document/controller/document.view.controller.dart';
import 'package:celebrated/document/model/doc.element.dart';
import 'package:celebrated/document/model/doc.element.type.dart';
import 'package:celebrated/document/model/document.dart';
import 'package:celebrated/domain/view/app.page.view.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:celebrated/util/list.extention.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DocumentViewer extends AppPageView{
  DocumentViewer({super.key});

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    final ADoc doc = DocumentsController.getADocByRoute();
    return Center(
      child: SizedBox(
        // alignment: Alignment.topCenter,
        width: adapter.adapt(phone: Get.width, tablet: Get.width, desktop: 800),
       /// color: Colors.white,
        child: ListView(
          padding: EdgeInsets.all(12),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(doc.name,style: adapter.textTheme.displaySmall,),
            ),
            ...doc.elements.map2((DocElement element,index) {
              switch (element.type) {
                case DocElType.paragraph:

                  return Padding(
                    padding: const EdgeInsets.all(8.0).copyWith(left: (index > 0 && doc.elements[index-1].type == DocElType.bulletPoint)?20:8),
                    child: Text(
                      element.value,
                      style: adapter.textTheme.bodyMedium,
                    ),
                  );
                case DocElType.title:
                  return Padding(
                    padding: const EdgeInsets.all(2.0).copyWith(top: 18),
                    child: Text(
                      element.value,
                      style: adapter.textTheme.headlineMedium,
                    ),
                  );
                case DocElType.image:
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      element.value,
                      width: 300,
                    ),
                  );
                case DocElType.bulletPoint:
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 28,
                          padding: EdgeInsets.all(3),
                          child: Icon(
                            Icons.circle,
                            color: Colors.black12,
                            size: 12,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              element.value,
                              style: adapter.textTheme.bodyMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
              }
            }).toList()
          ],
        ),
      ),
    );
  }
}
