(function(from, to) {
  var fso = new ActiveXObject("Scripting.FileSystemObject");
  var log = fso.OpenTextFile(from, 1, true);
  var line = log.ReadLine();
  log.Close();
  var out = fso.OpenTextFile(to, 8, true);
  out.WriteLine(line);
  out.Close();
})(WScript.Arguments(0), WScript.Arguments(1))

