import '../models/country_summary_model.dart';
import '../models/country_details_model.dart';

class MockCountriesData {
  static List<CountrySummary> getCountriesSummary() {
    return [
      const CountrySummary(
        name: 'Spain',
        flag: 'https://flagcdn.com/w320/es.png',
        population: 47351567,
        cca2: 'ES',
      ),
      const CountrySummary(
        name: 'United Kingdom',
        flag: 'https://flagcdn.com/w320/gb.png',
        population: 67215293,
        cca2: 'GB',
      ),
      const CountrySummary(
        name: 'Germany',
        flag: 'https://flagcdn.com/w320/de.png',
        population: 83240525,
        cca2: 'DE',
      ),
      const CountrySummary(
        name: 'Italy',
        flag: 'https://flagcdn.com/w320/it.png',
        population: 60461826,
        cca2: 'IT',
      ),
      const CountrySummary(
        name: 'France',
        flag: 'https://flagcdn.com/w320/fr.png',
        population: 67391582,
        cca2: 'FR',
      ),
      const CountrySummary(
        name: 'Canada',
        flag: 'https://flagcdn.com/w320/ca.png',
        population: 38005238,
        cca2: 'CA',
      ),
      const CountrySummary(
        name: 'United States',
        flag: 'https://flagcdn.com/w320/us.png',
        population: 329484123,
        cca2: 'US',
      ),
      const CountrySummary(
        name: 'Brazil',
        flag: 'https://flagcdn.com/w320/br.png',
        population: 212559409,
        cca2: 'BR',
      ),
      const CountrySummary(
        name: 'Japan',
        flag: 'https://flagcdn.com/w320/jp.png',
        population: 125836021,
        cca2: 'JP',
      ),
      const CountrySummary(
        name: 'India',
        flag: 'https://flagcdn.com/w320/in.png',
        population: 1380004385,
        cca2: 'IN',
      ),
      const CountrySummary(
        name: 'China',
        flag: 'https://flagcdn.com/w320/cn.png',
        population: 1439323776,
        cca2: 'CN',
      ),
      const CountrySummary(
        name: 'Russia',
        flag: 'https://flagcdn.com/w320/ru.png',
        population: 144104080,
        cca2: 'RU',
      ),
      const CountrySummary(
        name: 'Australia',
        flag: 'https://flagcdn.com/w320/au.png',
        population: 25687041,
        cca2: 'AU',
      ),
      const CountrySummary(
        name: 'Mexico',
        flag: 'https://flagcdn.com/w320/mx.png',
        population: 128932753,
        cca2: 'MX',
      ),
      const CountrySummary(
        name: 'South Korea',
        flag: 'https://flagcdn.com/w320/kr.png',
        population: 51780579,
        cca2: 'KR',
      ),
    ];
  }
  
  static CountryDetails? getCountryDetails(String cca2) {
    final detailsMap = {
      'ES': const CountryDetails(
        name: 'Spain',
        flags: 'https://flagcdn.com/w320/es.png',
        population: 47351567,
        capital: ['Madrid'],
        region: 'Europe',
        subregion: 'Southern Europe',
        area: 505992.0,
        timezones: ['UTC+01:00'],
      ),
      'GB': const CountryDetails(
        name: 'United Kingdom',
        flags: 'https://flagcdn.com/w320/gb.png',
        population: 67215293,
        capital: ['London'],
        region: 'Europe',
        subregion: 'Northern Europe',
        area: 242900.0,
        timezones: ['UTC-08:00', 'UTC-05:00', 'UTC-04:00', 'UTC-03:00', 'UTC+00:00', 'UTC+01:00', 'UTC+02:00', 'UTC+06:00'],
      ),
      'DE': const CountryDetails(
        name: 'Germany',
        flags: 'https://flagcdn.com/w320/de.png',
        population: 83240525,
        capital: ['Berlin'],
        region: 'Europe',
        subregion: 'Western Europe',
        area: 357114.0,
        timezones: ['UTC+01:00'],
      ),
      'IT': const CountryDetails(
        name: 'Italy',
        flags: 'https://flagcdn.com/w320/it.png',
        population: 60461826,
        capital: ['Rome'],
        region: 'Europe',
        subregion: 'Southern Europe',
        area: 301336.0,
        timezones: ['UTC+01:00'],
      ),
      'FR': const CountryDetails(
        name: 'France',
        flags: 'https://flagcdn.com/w320/fr.png',
        population: 67391582,
        capital: ['Paris'],
        region: 'Europe',
        subregion: 'Western Europe',
        area: 551695.0,
        timezones: ['UTC-10:00', 'UTC-09:30', 'UTC-09:00', 'UTC-08:00', 'UTC-04:00', 'UTC-03:00', 'UTC+01:00', 'UTC+03:00', 'UTC+04:00', 'UTC+05:00', 'UTC+10:00', 'UTC+11:00', 'UTC+12:00'],
      ),
      'CA': const CountryDetails(
        name: 'Canada',
        flags: 'https://flagcdn.com/w320/ca.png',
        population: 38005238,
        capital: ['Ottawa'],
        region: 'Americas',
        subregion: 'North America',
        area: 9984670.0,
        timezones: ['UTC-08:00', 'UTC-07:00', 'UTC-06:00', 'UTC-05:00', 'UTC-04:00', 'UTC-03:30', 'UTC-03:00'],
      ),
      'US': const CountryDetails(
        name: 'United States',
        flags: 'https://flagcdn.com/w320/us.png',
        population: 329484123,
        capital: ['Washington, D.C.'],
        region: 'Americas',
        subregion: 'North America',
        area: 9372610.0,
        timezones: ['UTC-12:00', 'UTC-11:00', 'UTC-10:00', 'UTC-09:00', 'UTC-08:00', 'UTC-07:00', 'UTC-06:00', 'UTC-05:00', 'UTC-04:00', 'UTC+10:00', 'UTC+12:00'],
      ),
      'BR': const CountryDetails(
        name: 'Brazil',
        flags: 'https://flagcdn.com/w320/br.png',
        population: 212559409,
        capital: ['Brasília'],
        region: 'Americas',
        subregion: 'South America',
        area: 8515767.0,
        timezones: ['UTC-05:00', 'UTC-04:00', 'UTC-03:00', 'UTC-02:00'],
      ),
      'JP': const CountryDetails(
        name: 'Japan',
        flags: 'https://flagcdn.com/w320/jp.png',
        population: 125836021,
        capital: ['Tokyo'],
        region: 'Asia',
        subregion: 'Eastern Asia',
        area: 377930.0,
        timezones: ['UTC+09:00'],
      ),
      'IN': const CountryDetails(
        name: 'India',
        flags: 'https://flagcdn.com/w320/in.png',
        population: 1380004385,
        capital: ['New Delhi'],
        region: 'Asia',
        subregion: 'Southern Asia',
        area: 3287590.0,
        timezones: ['UTC+05:30'],
      ),
    };
    
    return detailsMap[cca2];
  }
}
