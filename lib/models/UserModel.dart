class User{
  String userId;
  String imgUrl;
  String name;
  String lowerCaseName;
  String email;
  String bio;
  String phone;
  String privacy;

  User({this.name,this.email,this.userId,this.imgUrl,this.lowerCaseName,this.bio,this.phone,this.privacy});

  Map toMap(User user){
    var data=Map<String,dynamic>();
    data['Name']=user.name;
    data['Privacy']=user.privacy;
    data['Phone']=user.phone;
    data['ProfileImage']=user.imgUrl;
    data['Email']=user.email;
    data['LowerCaseName']=user.lowerCaseName;
    data['UserId']=user.userId;
    data['Bio']=user.bio;
    return data;
  }

  User.fromMap(Map<String,dynamic> mapData){
    this.userId=mapData['UserId'];
    this.email=mapData['Email'];
    this.name=mapData['Name'];
    this.imgUrl=mapData['ProfileImage'];
    this.privacy=mapData['Privacy'];
    this.lowerCaseName=mapData['LowerCaseName'];
    this.bio=mapData['Bio'];
    this.phone=mapData['Phone'];
  }

}
