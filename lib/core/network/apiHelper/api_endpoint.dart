
class ApiEndPoint{

  static final ApiEndPoint _instance = ApiEndPoint._internal();

  factory ApiEndPoint(){
    return _instance;
  }

  ApiEndPoint._internal();

  //static const baseurl = "http://192.168.29.243:8001/api";
  static const baseurl = "https://thecityofjoy.in/educare_api/api";

  // for example

  static const test =  "$baseurl/api/galleries";
  static const test1 =  "$baseurl/api/chambers";


  // auth module
  static const instituteList =  "$baseurl/get_all_school_list";
  static const schoolList =  "$baseurl/get_all_school_list/0";
  static const collegeList =  "$baseurl/get_all_school_list/1";
  static const login =  "$baseurl/user_login";


  // student  module
  static const getDashboardMarks =  "$baseurl/get_dashboard_header";
  static const latestEventList =  "$baseurl/latest_event_list";
  static const classNotesAndHomeTask =  "$baseurl/class_notes_and_home_task";
  static const getNoticeList =  "$baseurl/get_notice";
  static const getUserAttendanceGraphData =  "$baseurl/get_user_attendance_today_graph";
  static const getImidiateAction =  "$baseurl/imidiate_action";
  static const examFeesGraphData =  "$baseurl/get_user_fees_collection_graph";



  // teacher module
  static const getClassList =  "$baseurl/get_all_class_list";
  static const getPieChartAttendance =  "$baseurl/class_absent_present_data";
  static const latestEventListTeacher =  "$baseurl/latest_event_list";
  static const allStudentList =  "$baseurl/get_session_for_class_student";
  static const savedAttendance =  "$baseurl/save_attendance";
  static const getDepartmentList =  "$baseurl/getDepartments";
  static const getClassListForTask =  "$baseurl/getClass";
  static const getSectionList =  "$baseurl/sectionForClasses";
  static const getSubjectList =  "$baseurl/subject_list";
  static const createTask =  "$baseurl/save_hometask";
  static const getStudentList =  "$baseurl/get_student_data_for_home_task";
  static const getTodayAnalysisList =  "$baseurl/todays_analysis";
  static const getNotesAndAssignmentList =  "$baseurl/class_notes_and_home_task";
  static const getCurrentClassRoutineList =  "$baseurl/teacher_class_routine";
  static const getMyHealthList =  "$baseurl/getCandidateMentalHealth";


  //parent module
  static const parentChildrens =  "$baseurl/parent_childrens";








}