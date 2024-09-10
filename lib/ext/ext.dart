export 'convert_ext.dart';
export 'extension.dart';
export 'widget_ext.dart';
export 'date_ext.dart';

//extension AppResponseExt<T> on AppResponse<T> {
//   doFunc(
//       {required Success<T> success, Failure? failure, FinalFunc? finalFunc}) {
//     if (ok) {
//       var data = this.data;
//       success.call(data);
//     } else {
//       failure?.call(code, msg);
//     }
//     finalFunc?.call(ok);
//   }
// }
