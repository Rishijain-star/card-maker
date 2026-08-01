import 'dart:convert';

class LoginModel {
    int? code;
    bool? status;
    String? message;
    Data? data;

    LoginModel({
        this.code,
        this.status,
        this.message,
        this.data,
    });

    factory LoginModel.fromRawJson(String str) => LoginModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        code: json["code"],
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    String? perPriceKg;
    String? offerId;
    Offer? offer;
    UserClass? user;
    Status? status;

    Data({
        this.perPriceKg,
        this.offerId,
        this.offer,
        this.user,
        this.status,
    });

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        perPriceKg: json["per_price_kg"],
        offerId: json["offer_id"],
        offer: json["offer"] == null ? null : Offer.fromJson(json["offer"]),
        user: json["user"] == null ? null : UserClass.fromJson(json["user"]),
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
    );

    Map<String, dynamic> toJson() => {
        "per_price_kg": perPriceKg,
        "offer_id": offerId,
        "offer": offer?.toJson(),
        "user": user?.toJson(),
        "status": status?.toJson(),
    };
}

class Offer {
    DateTime? departureDate;
    String? availableWeight;
    DateTime? arrivalDate;
    String? pricePerKg;
    String? pricePerKgOld;
    String? weightKg;
    PaymentMethod? paymentMethod;
    String? yourPotentialEarning;
    int? id;
    String? offerNumber;
    int? userId;
    int? offerFromCountry;
    int? offerToCountry;
    String? transportType;
    String? firstName;
    String? surname;
    String? mobileNumber;
    String? whatsappNumber;
    String? email;
    String? streetName;
    String? houseNumber;
    String? postalCode;
    String? city;
    String? addressCountry;
    String? status;
    String? currency;
    int? pricingId;
    DateTime? createdAt;
    int? fromCityId;
    int? toCityId;
    User? user;
    Country? fromCountry;
    Country? toCountry;
    City? fromCity;
    City? toCity;
    AddRoute? addRoute;

    Offer({
        this.departureDate,
        this.availableWeight,
        this.arrivalDate,
        this.pricePerKg,
        this.pricePerKgOld,
        this.weightKg,
        this.paymentMethod,
        this.yourPotentialEarning,
        this.id,
        this.offerNumber,
        this.userId,
        this.offerFromCountry,
        this.offerToCountry,
        this.transportType,
        this.firstName,
        this.surname,
        this.mobileNumber,
        this.whatsappNumber,
        this.email,
        this.streetName,
        this.houseNumber,
        this.postalCode,
        this.city,
        this.addressCountry,
        this.status,
        this.currency,
        this.pricingId,
        this.createdAt,
        this.fromCityId,
        this.toCityId,
        this.user,
        this.fromCountry,
        this.toCountry,
        this.fromCity,
        this.toCity,
        this.addRoute,
    });

    factory Offer.fromRawJson(String str) => Offer.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        departureDate: json["departure_date"] == null ? null : DateTime.parse(json["departure_date"]),
        availableWeight: json["available_weight"],
        arrivalDate: json["arrival_date"] == null ? null : DateTime.parse(json["arrival_date"]),
        pricePerKg: json["price_per_kg"],
        pricePerKgOld: json["price_per_kg_old"],
        weightKg: json["weight_kg"],
        paymentMethod: json["payment_method"] == null ? null : PaymentMethod.fromJson(json["payment_method"]),
        yourPotentialEarning: json["your_potential_earning"],
        id: json["id"],
        offerNumber: json["offer_number"],
        userId: json["user_id"],
        offerFromCountry: json["from_country"],
        offerToCountry: json["to_country"],
        transportType: json["transport_type"],
        firstName: json["first_name"],
        surname: json["surname"],
        mobileNumber: json["mobile_number"],
        whatsappNumber: json["whatsapp_number"],
        email: json["email"],
        streetName: json["street_name"],
        houseNumber: json["house_number"],
        postalCode: json["postal_code"],
        city: json["city"],
        addressCountry: json["address_country"],
        status: json["status"],
        currency: json["currency"],
        pricingId: json["pricing_id"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        fromCityId: json["from_city_id"],
        toCityId: json["to_city_id"],
        user: json["User"] == null ? null : User.fromJson(json["User"]),
        fromCountry: json["fromCountry"] == null ? null : Country.fromJson(json["fromCountry"]),
        toCountry: json["toCountry"] == null ? null : Country.fromJson(json["toCountry"]),
        fromCity: json["fromCity"] == null ? null : City.fromJson(json["fromCity"]),
        toCity: json["toCity"] == null ? null : City.fromJson(json["toCity"]),
        addRoute: json["addRoute"] == null ? null : AddRoute.fromJson(json["addRoute"]),
    );

    Map<String, dynamic> toJson() => {
        "departure_date": departureDate?.toIso8601String(),
        "available_weight": availableWeight,
        "arrival_date": arrivalDate?.toIso8601String(),
        "price_per_kg": pricePerKg,
        "price_per_kg_old": pricePerKgOld,
        "weight_kg": weightKg,
        "payment_method": paymentMethod?.toJson(),
        "your_potential_earning": yourPotentialEarning,
        "id": id,
        "offer_number": offerNumber,
        "user_id": userId,
        "from_country": offerFromCountry,
        "to_country": offerToCountry,
        "transport_type": transportType,
        "first_name": firstName,
        "surname": surname,
        "mobile_number": mobileNumber,
        "whatsapp_number": whatsappNumber,
        "email": email,
        "street_name": streetName,
        "house_number": houseNumber,
        "postal_code": postalCode,
        "city": city,
        "address_country": addressCountry,
        "status": status,
        "currency": currency,
        "pricing_id": pricingId,
        "createdAt": createdAt?.toIso8601String(),
        "from_city_id": fromCityId,
        "to_city_id": toCityId,
        "User": user?.toJson(),
        "fromCountry": fromCountry?.toJson(),
        "toCountry": toCountry?.toJson(),
        "fromCity": fromCity?.toJson(),
        "toCity": toCity?.toJson(),
        "addRoute": addRoute?.toJson(),
    };
}

class AddRoute {
    int? frozenTimeBeforeTrip;
    int? frozenTimeAfterTrip;

    AddRoute({
        this.frozenTimeBeforeTrip,
        this.frozenTimeAfterTrip,
    });

    factory AddRoute.fromRawJson(String str) => AddRoute.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory AddRoute.fromJson(Map<String, dynamic> json) => AddRoute(
        frozenTimeBeforeTrip: json["frozen_time_before_trip"],
        frozenTimeAfterTrip: json["frozen_time_after_trip"],
    );

    Map<String, dynamic> toJson() => {
        "frozen_time_before_trip": frozenTimeBeforeTrip,
        "frozen_time_after_trip": frozenTimeAfterTrip,
    };
}

class City {
    int? id;
    String? name;

    City({
        this.id,
        this.name,
    });

    factory City.fromRawJson(String str) => City.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}

class Country {
    int? id;
    String? name;
    String? iso2Cc;

    Country({
        this.id,
        this.name,
        this.iso2Cc,
    });

    factory Country.fromRawJson(String str) => Country.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        name: json["name"],
        iso2Cc: json["iso2_cc"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "iso2_cc": iso2Cc,
    };
}

class PaymentMethod {
    String? type;
    Iban? iban;
    Paypal? paypal;
    AlifBank? alifBank;

    PaymentMethod({
        this.type,
        this.iban,
        this.paypal,
        this.alifBank,
    });

    factory PaymentMethod.fromRawJson(String str) => PaymentMethod.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        type: json["type"],
        iban: json["iban"] == null ? null : Iban.fromJson(json["iban"]),
        paypal: json["paypal"] == null ? null : Paypal.fromJson(json["paypal"]),
        alifBank: json["alif_bank"] == null ? null : AlifBank.fromJson(json["alif_bank"]),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "iban": iban?.toJson(),
        "paypal": paypal?.toJson(),
        "alif_bank": alifBank?.toJson(),
    };
}

class AlifBank {
    String? mobileNumber;

    AlifBank({
        this.mobileNumber,
    });

    factory AlifBank.fromRawJson(String str) => AlifBank.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory AlifBank.fromJson(Map<String, dynamic> json) => AlifBank(
        mobileNumber: json["mobile_number"],
    );

    Map<String, dynamic> toJson() => {
        "mobile_number": mobileNumber,
    };
}

class Iban {
    String? firstName;
    String? surname;
    String? ibanNumber;

    Iban({
        this.firstName,
        this.surname,
        this.ibanNumber,
    });

    factory Iban.fromRawJson(String str) => Iban.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Iban.fromJson(Map<String, dynamic> json) => Iban(
        firstName: json["first_name"],
        surname: json["surname"],
        ibanNumber: json["iban_number"],
    );

    Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "surname": surname,
        "iban_number": ibanNumber,
    };
}

class Paypal {
    String? email;

    Paypal({
        this.email,
    });

    factory Paypal.fromRawJson(String str) => Paypal.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Paypal.fromJson(Map<String, dynamic> json) => Paypal(
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
    };
}

class User {
    String? profileImage;
    int? id;
    String? firstName;

    User({
        this.profileImage,
        this.id,
        this.firstName,
    });

    factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory User.fromJson(Map<String, dynamic> json) => User(
        profileImage: json["profile_image"],
        id: json["id"],
        firstName: json["first_name"],
    );

    Map<String, dynamic> toJson() => {
        "profile_image": profileImage,
        "id": id,
        "first_name": firstName,
    };
}

class Status {
    DateTime? createdAt;
    DateTime? deliveryAt;

    Status({
        this.createdAt,
        this.deliveryAt,
    });

    factory Status.fromRawJson(String str) => Status.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Status.fromJson(Map<String, dynamic> json) => Status(
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        deliveryAt: json["delivery_at"] == null ? null : DateTime.parse(json["delivery_at"]),
    );

    Map<String, dynamic> toJson() => {
        "created_at": createdAt?.toIso8601String(),
        "delivery_at": deliveryAt?.toIso8601String(),
    };
}

class UserClass {
    String? name;
    String? profileImage;

    UserClass({
        this.name,
        this.profileImage,
    });

    factory UserClass.fromRawJson(String str) => UserClass.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory UserClass.fromJson(Map<String, dynamic> json) => UserClass(
        name: json["name"],
        profileImage: json["profile_image"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "profile_image": profileImage,
    };
}

