import 'package:get/get.dart';
import 'package:meta/meta.dart';

class SubjectPageController extends GetxController {

  final List<String> _subjects = getSubjects().obs;
  set subjects(value) => _subjects.assignAll(value) ;
  get subjects => _subjects;
}
List<String> getSubjects()  {
  List<String> a = [];
  a.add("sub1");
  a.add("sub2");
  a.add("sub3");
  return a;
}