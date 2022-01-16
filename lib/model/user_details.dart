class UserDetails {
  String name;
  String imagePath;
  String address;

  UserDetails(this.name, this.imagePath, this.address);

  static UserDetails getByIndex(int i){
    return UserDetails("Uhh She Upp", 'https://i.pinimg.com/originals/26/42/26/26422665b452967ebc301deadb2a036d.jpg', '015 Rolfson Inlet Apt. 700, ...');
  }
}