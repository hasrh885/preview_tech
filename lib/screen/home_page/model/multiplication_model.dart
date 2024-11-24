import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
    int? multiplayer;
    String? text;
    String? total;

    Welcome({
        this.multiplayer,
        this.text,
        this.total,
    });

    factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        multiplayer: json["multiplayer"],
        text: json["text"],
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "multiplayer": multiplayer,
        "text": text,
        "total": total,
    };
}