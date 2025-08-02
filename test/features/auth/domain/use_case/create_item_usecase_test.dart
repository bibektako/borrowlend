import 'package:flutter_test/flutter_test.dart';
import 'package:borrowlend/features/category/domain/entity/category_entity.dart';

void main() {
  group('CategoryEntity', () {
    CategoryEntity createSubject({
      String categoryId = '123',
      String category = 'Electronics',
      String category_image = 'electronics.png',
    }) {
      return CategoryEntity(
        categoryId: categoryId,
        category: category,
        category_image: category_image,
      );
    }

    test('supports value equality', () {
      final instanceA = createSubject();
      final instanceB = createSubject();
      
      expect(instanceA, equals(instanceB));
    });

    test('props list contains the correct properties', () {
      final instance = createSubject();

      expect(instance.props, [
        '123', // categoryId
        'Electronics', // category
        'electronics.png', // category_image
      ]);
    });

    test('instances with different properties are not equal', () {
      
      final instanceA = createSubject();
      final instanceB = createSubject(categoryId: '456'); // Different ID

      expect(instanceA, isNot(equals(instanceB)));
    });
  });
}