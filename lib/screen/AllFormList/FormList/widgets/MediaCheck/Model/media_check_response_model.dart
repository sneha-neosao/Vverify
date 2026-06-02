class MediaCheckResponseModel {
  final int? status;
  final String? message;
  final MediaCheckData? data;
  final String? uid;
  final String? pdfUrl;

  MediaCheckResponseModel({
    this.status,
    this.message,
    this.data,
    this.uid,
    this.pdfUrl,
  });

  factory MediaCheckResponseModel.fromJson(Map<String, dynamic> json) {
    return MediaCheckResponseModel(
      status: json['status'] is int
          ? json['status']
          : int.tryParse(json['status']?.toString() ?? ''),
      message: json['message']?.toString(),
      data: json['data'] != null ? MediaCheckData.fromJson(json['data']) : null,
      uid: json['uid']?.toString(),
      pdfUrl: json['pdf_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
      'uid': uid,
      'pdf_url': pdfUrl,
    };
  }
}

class MediaCheckData {
  final List<MediaNewsItem>? data;
  final int? credits;
  final String? message;

  MediaCheckData({
    this.data,
    this.credits,
    this.message,
  });

  factory MediaCheckData.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List?;
    List<MediaNewsItem>? newsList =
        list?.map((i) => MediaNewsItem.fromJson(i)).toList();

    return MediaCheckData(
      data: newsList,
      credits: json['credits'] is int
          ? json['credits']
          : int.tryParse(json['credits']?.toString() ?? ''),
      message: json['message']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.map((e) => e.toJson()).toList(),
      'credits': credits,
      'message': message,
    };
  }
}

class MediaNewsItem {
  final String? title;
  final String? link;
  final MediaGuid? guid;
  final String? pubDate;
  final String? description;
  final MediaSource? source;

  MediaNewsItem({
    this.title,
    this.link,
    this.guid,
    this.pubDate,
    this.description,
    this.source,
  });

  factory MediaNewsItem.fromJson(Map<String, dynamic> json) {
    return MediaNewsItem(
      title: json['title']?.toString(),
      link: json['link']?.toString(),
      guid: json['guid'] != null ? MediaGuid.fromJson(json['guid']) : null,
      pubDate: json['pubDate']?.toString(),
      description: json['description']?.toString(),
      source:
          json['source'] != null ? MediaSource.fromJson(json['source']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'link': link,
      'guid': guid?.toJson(),
      'pubDate': pubDate,
      'description': description,
      'source': source?.toJson(),
    };
  }
}

class MediaGuid {
  final String? isPermaLink;
  final String? t;

  MediaGuid({
    this.isPermaLink,
    this.t,
  });

  factory MediaGuid.fromJson(Map<String, dynamic> json) {
    return MediaGuid(
      isPermaLink: json['isPermaLink']?.toString(),
      t: json[r'$t']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isPermaLink': isPermaLink,
      r'$t': t,
    };
  }
}

class MediaSource {
  final String? url;
  final String? t;

  MediaSource({
    this.url,
    this.t,
  });

  factory MediaSource.fromJson(Map<String, dynamic> json) {
    return MediaSource(
      url: json['url']?.toString(),
      t: json[r'$t']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      r'$t': t,
    };
  }
}

// Model classes for verify/media-check/show API
class MediaCheckShowResponseModel {
  final int? status;
  final String? message;
  final MediaCheckShowData? data;

  MediaCheckShowResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory MediaCheckShowResponseModel.fromJson(Map<String, dynamic> json) {
    return MediaCheckShowResponseModel(
      status: json['status'] is int
          ? json['status']
          : int.tryParse(json['status']?.toString() ?? ''),
      message: json['message']?.toString(),
      data: json['data'] != null
          ? MediaCheckShowData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class MediaCheckShowData {
  final String? uid;
  final int? requestId;
  final String? keyword;
  final String? status;
  final MediaCheckData? apiResponse;
  final String? documentPath;
  final String? pdfUrl;
  final String? verifiedAt;

  MediaCheckShowData({
    this.uid,
    this.requestId,
    this.keyword,
    this.status,
    this.apiResponse,
    this.documentPath,
    this.pdfUrl,
    this.verifiedAt,
  });

  factory MediaCheckShowData.fromJson(Map<String, dynamic> json) {
    return MediaCheckShowData(
      uid: json['uid']?.toString(),
      requestId: json['request_id'] is int
          ? json['request_id']
          : int.tryParse(json['request_id']?.toString() ?? ''),
      keyword: json['keyword']?.toString(),
      status: json['status']?.toString(),
      apiResponse: json['api_response'] != null
          ? MediaCheckData.fromJson(json['api_response'])
          : null,
      documentPath: json['document_path']?.toString(),
      pdfUrl: json['pdf_url']?.toString(),
      verifiedAt: json['verified_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'request_id': requestId,
      'keyword': keyword,
      'status': status,
      'api_response': apiResponse?.toJson(),
      'document_path': documentPath,
      'pdf_url': pdfUrl,
      'verified_at': verifiedAt,
    };
  }
}
