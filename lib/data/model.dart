class SocialMedia {
  final String name;
  final String url;

  SocialMedia({required this.name, required this.url});

  factory SocialMedia.fromJson(Map<String, dynamic> json) =>
      SocialMedia(name: json['name'] as String, url: json['url'] as String);

  Map<String, dynamic> toJson() => {'name': name, 'url': url};
}

class Ad {
  final String id;
  final String image;
  final String title;
  final String description;
  final String address;
  final String phone;
  final SocialMedia facebook;
  final SocialMedia instagram;
  final String callToActionUrl;

  Ad({
    required this.id,
    required this.image,
    required this.title,
    required this.description,
    required this.address,
    required this.phone,
    required this.facebook,
    required this.instagram,
    required this.callToActionUrl,
  });

  factory Ad.fromJson(Map<String, dynamic> json) => Ad(
    id: json['id'] as String,
    image: json['image'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    address: json['address'] as String,
    phone: json['phone'] as String,
    facebook: SocialMedia.fromJson(json['facebook'] as Map<String, dynamic>),
    instagram: SocialMedia.fromJson(json['instagram'] as Map<String, dynamic>),
    callToActionUrl: json['callToActionUrl'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'image': image,
    'title': title,
    'description': description,
    'address': address,
    'phone': phone,
    'facebook': facebook.toJson(),
    'instagram': instagram.toJson(),
    'callToActionUrl': callToActionUrl,
  };
}
