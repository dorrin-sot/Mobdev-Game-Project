import 'package:get/get.dart';
import 'package:meta/meta.dart';

class SubjectPageController extends GetxController {
  //todo make it future and get data from backend
  final List<String> _subjects = getSubjects().obs;
  set subjects(value) => _subjects.assignAll(value) ;
  get subjects => _subjects;
}
List<String> getSubjects()  {
  List<String> a = [];
  a.add("sub1");
  a.add("sub2");
  a.add("sub3");
  a.add("sub1");
  a.add("sub2");
  a.add("sub3");
  a.add("sub1");
  a.add("sub2");
  a.add("sub3");
  a.add("sub1");
  a.add("sub2");
  a.add("sub3");
  a.add("sub1");
  a.add("sub2");
  a.add("sub3");
  a.add("sub3");
  a.add("sub3");
  a.add("sub2");
  a.add("sub2");
  a.add("sub2");
  a.add("sub2");
  a.add("sub2");
  a.add("sub2");
  return a;
}