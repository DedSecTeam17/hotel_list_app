import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_list_app/core/network/api_response.dart';
import 'package:hotel_list_app/features/hotels/data/datasources/hotel_remote_data_source.dart';
import 'package:hotel_list_app/features/hotels/data/models/hotels_data_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  late HotelRemoteDataSourceImpl remoteDataSource;
  late http.Client mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient((request) async {
      return http.Response(fakeJson, 200);
    });
    remoteDataSource = HotelRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('HotelRemoteDataSourceImpl', () {
    test('should return HotelsDataModel when response code is 200', () async {
      remoteDataSource = HotelRemoteDataSourceImpl(
        client: MockClient((request) async {
          return http.Response(fakeJson, 200);
        }),
      );
      final result = await remoteDataSource.getHotelsData(page: 1);
      expect(result.isSuccess, true);
      expect(result.errorMessage, isNull);
      expect(result, isA<ApiResponse<HotelsDataModel>>());
    });

    test('should return error when response code is 500', () async {
      remoteDataSource = HotelRemoteDataSourceImpl(
        client: MockClient((request) async {
          return http.Response('Server error', 500);
        }),
      );
      final result = await remoteDataSource.getHotelsData(page: 1);
      expect(result.isSuccess, false);
      expect(result.errorMessage, isNotNull);
    });

    test('should handle timeout exception', () async {
      remoteDataSource = HotelRemoteDataSourceImpl(
        client: MockClient((request) async {
          await Future.delayed(
              const Duration(seconds: 11)); // longer than 10s timeout
          return http.Response(fakeJson, 200);
        }),
      );
      final result = await remoteDataSource.getHotelsData(page: 1);
      expect(result.isSuccess, false);
      expect(result.errorMessage, isNotNull);
    });
  });
}

const fakeJson = '''
{
  "filters": [
    {
      "name": "Venue type",
      "type": "multi",
      "categories": [
        {
          "id": "Za41RRIAACMA22aW",
          "name": "Hotel"
        },
        {
          "id": "Za41ahIAACUA22bN",
          "name": "Beach club"
        },
        {
          "id": "Za41hhIAAC7M22b5",
          "name": "Community club"
        }
      ]
    },
    {
      "name": "Hotel facilities",
      "type": "multi",
      "categories": [
        {
          "id": "XE_8nhEAACIA_nYT",
          "name": "Beach"
        },
        {
          "id": "XE_8uxEAACEA_nab",
          "name": "Adults-only pool"
        },
        {
          "id": "XE_9MBEAACAA_niz",
          "name": "Lap pool"
        },
        {
          "id": "Yv82ERAAAPgZB5xS",
          "name": "Kids pool"
        },
        {
          "id": "YxrmsBEAAHzJoyML",
          "name": "Rooftop pool"
        },
        {
          "id": "YzPhZxEAAM-gifhg",
          "name": "Swim-up bar"
        }
      ]
    }
  ],
  "items": [
    {
      "section": "hotel",
      "name": " Al Raha Beach Resort & Spa",
      "city": "Abu Dhabi",
      "type": "hotel",
      "coordinates": {
        "lat": 24.438300444955136,
        "lng": 54.57247138023377
      },
      "location": "Channel Street",
      "images": [
        {
          "url": "https://privilee-media.imgix.net/privilee/0863afca-4cce-451a-ba1f-c3030a00de88_Al+Raha+beach_NEW+2023_08.png?auto=compress,format"
        },
        {
          "url": "https://privilee-media.imgix.net/privilee/371becdb-d91f-4835-a881-2534ca38f878_Al+Raha+beach_NEW+2023_12.png?auto=compress,format"
        },
        {
          "url": "https://privilee-media.imgix.net/privilee/0467bd3a-89a0-4176-b184-d08db311b512_Al+Raha+beach_NEW+2023_07.png?auto=compress,format"
        }
      ],
      "categories": [
        {
          "id": "XE_9TBEAACMA_nkt",
          "category": "Free nanny access",
          "title": "For one nanny, per family",
          "detail": [
            {
              "type": "list-item",
              "text": "Nannies are not permitted to use the facilities",
              "spans": []
            }
          ],
          "showOnVenuePage": true
        },
        {
          "id": "YvODwhAAAP0n04G8",
          "category": "Free access for 3 kids",
          "title": "Aged 4 - 12",
          "detail": [
            {
              "type": "list-item",
              "text": "Free access for infants and up to three kids, per family",
              "spans": []
            }
          ],
          "showOnVenuePage": true
        },
        {
          "id": "YvORghAAAP0n08Ns",
          "category": "Free access for 2 kids",
          "title": "Aged 4 - 12",
          "detail": [
            {
              "type": "list-item",
              "text": "Free access for infants and up to three kids, per family",
              "spans": []
            }
          ],
          "showOnVenuePage": false
        },
        {
          "id": "Yv82ERAAAPgZB5xS",
          "category": "Kids pool",
          "title": "Shaded kids pool",
          "detail": [
            {
              "type": "list-item",
              "text": "Complimentary sun loungers and towels",
              "spans": []
            }
          ],
          "showOnVenuePage": false
        },
        {
          "id": "XE_8nhEAACIA_nYT",
          "category": "Beach",
          "title": "Beach",
          "detail": [
            {
              "type": "list-item",
              "text": "Complimentary sun loungers and towels",
              "spans": []
            }
          ],
          "showOnVenuePage": false
        },
        {
          "id": "YzPPkBEAANURiak3",
          "category": "Venue guest rates",
          "title": "From AED 125",
          "detail": [
            {
              "type": "list-item",
              "text": "Monday to Friday: Adults - AED 125, Kids - AED 90",
              "spans": []
            },
            {
              "type": "list-item",
              "text": "Saturday & Sunday: Adults - AED 175, Kids - AED 125",
              "spans": []
            }
          ],
          "showOnVenuePage": false
        },
        {
          "id": "Za41RRIAACMA22aW",
          "category": "Hotel",
          "showOnVenuePage": false
        }
      ],
      "openingHours": {},
      "accessibleForGuestPass": true,
      "overviewText": [
        {
          "type": "paragraph",
          "text": "Get ready for family adventures at this friendly resort, boasting four pools (two for kids!), a HUGE 900-metre beach, squash courts and an array of tasty dining venues - where Privilee Members save 25%.",
          "spans": []
        }
      ],
      "thingsToDo": [
        {
          "title": "Free nanny access",
          "badge": "For one nanny, per family",
          "content": [
            [
              {
                "type": "list-item",
                "text": "Nannies are not permitted to use the facilities",
                "spans": []
              }
            ]
          ]
        },
        {
          "title": "Free access for 3 kids",
          "badge": "Aged 4 - 12",
          "content": [
            [
              {
                "type": "list-item",
                "text": "Free access for infants and up to three kids, per family",
                "spans": []
              }
            ]
          ]
        },
        {
          "title": "Pool & beach",
          "badge": "Free access",
          "items": [
            {
              "image": {
                "url": "https://images.prismic.io/privilee/5f7f782c-8358-4240-bc59-d7c493db7192_Al+Raha+beach_NEW+2023_06.png?auto=compress,format"
              },
              "title": ""
            },
            {
              "image": {
                "url": "https://images.prismic.io/privilee/6e7e5e6d-3ff3-4550-9834-5a106e7e674c_Al+Raha+beach_NEW+2023_05.png?auto=format,compress"
              },
              "title": ""
            },
            {
              "image": {
                "url": "https://images.prismic.io/privilee/58129cf9-fe3a-4418-aa44-882b41016a6f_Al+Raha+beach_NEW+2023_01.png?auto=compress,format"
              },
              "title": ""
            }
          ]
        },
        {
          "title": "Guest rates",
          "badge": "From AED 125",
          "content": [
            [
              {
                "type": "list-item",
                "text": "Monday to Friday: Adults - AED 125, Kids - AED 90",
                "spans": []
              },
              {
                "type": "list-item",
                "text": "Saturday & Sunday: Adults - AED 175, Kids - AED 125",
                "spans": []
              }
            ]
          ]
        },
        {
          "title": "Gazelle Kids Club",
          "subtitle": "10:00 - 19:00",
          "content": [
            [
              {
                "type": "heading3",
                "text": "Opening hours",
                "spans": []
              }
            ],
            [
              {
                "type": "paragraph",
                "text": "Monday to Sunday: 10 am - 7 pm",
                "spans": [],
                "direction": "ltr"
              }
            ],
            [
              {
                "type": "heading3",
                "text": "Complimentary access",
                "spans": []
              }
            ],
            [
              {
                "type": "list-item",
                "text": "Children must be aged 4 - 12 years old",
                "spans": [],
                "direction": "ltr"
              },
              {
                "type": "list-item",
                "text": "Gazelle Kids Club is available on a walk-in basis",
                "spans": [],
                "direction": "ltr"
              },
              {
                "type": "list-item",
                "text": "Supervised (kids can be dropped off and collected later) ",
                "spans": [],
                "direction": "ltr"
              },
              {
                "type": "list-item",
                "text": "Gazelle Kids Club is located next to the kids pool",
                "spans": [],
                "direction": "ltr"
              }
            ]
          ]
        },
        {
          "title": "Al Raha Gym",
          "subtitle": "8:00 - 22:00",
          "badge": "Free access"
        },
        {
          "title": "Body & Soul Spa",
          "subtitle": "12:00 - 24:00",
          "badge": "25% off"
        },
        {
          "title": "Restaurants",
          "badge": "25% off",
          "items": [
            {
              "title": "Al Manzil Restaurant & Bar",
              "image": {
                "url": "https://images.prismic.io/privilee/075af833-a711-4de8-b24a-5dd8144e59e7_Al+Raha+Beach_Al+Manzil.jpg?auto=compress,format"
              }
            },
            {
              "title": "Azur",
              "image": {
                "url": "https://images.prismic.io/privilee/0ed69c36-33c1-4895-b41c-8dfff6a7761f_Al+Raha+Beach_Azur+new+color.jpg?auto=compress,format"
              }
            },
            {
              "title": "Black Pearl",
              "image": {
                "url": "https://images.prismic.io/privilee/e53811ce-19a8-4d34-9207-62012e12efed_Al+Raha+Beach_Black+Pearl+Bar.jpg?auto=compress,format"
              }
            },
            {
              "title": "Cafe Mozart",
              "image": {
                "url": "https://images.prismic.io/privilee/3aaa83bd-64cb-452a-bbaf-fd79856ec79e_Al+Raha+Beach_Cafe+Mozart.jpg?auto=compress,format"
              }
            },
            {
              "title": "La Piscine Pool Bar & Restaurant",
              "image": {
                "url": "https://images.prismic.io/privilee/6b993b0f-3da9-47e8-9bea-f01417f0044a_Al+Raha+Beach_La+Piscine+sunset.jpg?auto=compress,format"
              }
            },
            {
              "title": "Saraya Tent",
              "image": {
                "url": "https://images.prismic.io/privilee/d5920b6b-5112-4ed0-b8ed-ca92193f8598_Al+Raha+Beach_Saraya+tent2.jpg?auto=compress,format"
              }
            },
            {
              "title": "Sevilla",
              "image": {
                "url": "https://images.prismic.io/privilee/da11f654-9ff8-4e1b-9de6-5aa612fbed05_Al+Raha+Beach_Sevilla.jpg?auto=compress,format"
              }
            },
            {
              "title": "Wanasah",
              "image": {
                "url": "https://images.prismic.io/privilee/960eb485-0048-4739-81a2-a42d86bcd152_Al+Raha+Beach_Wanasah.jpg?auto=compress,format"
              }
            }
          ]
        }
      ]
    }
  ]
}

  ''';
