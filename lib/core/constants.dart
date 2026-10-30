/// App-wide constants. No secrets live here — the API layer is a mock
/// (see ApiService) so the demo runs with zero keys. When a real backend
/// is wired in, only [apiBaseUrl] changes.
class AppConstants {
  static const appName = 'ServeNow';
  static const tagline = 'Services & essentials, at your door.';
  static const apiBaseUrl = 'https://api.servenow.demo/v1';
  static const demoEmail = 'demo@servenow.app';
  static const demoPassword = 'demo1234';
  static const supportPhone = '+92 300 1234567';
  static const freeDeliveryThreshold = 5000; // PKR — free delivery above this
  static const deliveryFee = 299; // PKR flat, waived above the threshold

  static const serviceCategories = <String>[
    'All',
    'Cleaning',
    'Plumbing',
    'Electrical',
    'AC Repair',
    'Salon',
    'Appliance',
    'Painting',
    'Car Wash',
  ];

  static const productCategories = <String>[
    'All',
    'Cleaning',
    'Tools',
    'Home',
    'Safety',
    'Garden',
  ];

  static const cities = <String>[
    'Islamabad',
    'Abbottabad',
    'Lahore',
    'Karachi',
    'Rawalpindi',
  ];
}
