import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'helpers/helpers.dart';

class MockRepository extends Mock implements Repository {}

void main() {
  group('blocTest', () {
    group('CounterBloc', () {
      blocTest(
        'emits [0] when nothing is added',
        build: () async => CounterBloc(),
        expect: [0],
      );

      blocTest(
        'emits [0, 1] when CounterEvent.increment is added',
        build: () async => CounterBloc(),
        act: (bloc) => bloc.add(CounterEvent.increment),
        expect: [0, 1],
      );

      blocTest(
        'emits [0, 1] when CounterEvent.increment is added with async act',
        build: () async => CounterBloc(),
        act: (bloc) async {
          await Future.delayed(Duration(seconds: 1));
          bloc.add(CounterEvent.increment);
        },
        expect: [0, 1],
      );

      blocTest(
        'emits [0, 1, 2] when CounterEvent.increment is called multiple times'
        'with async act',
        build: () async => CounterBloc(),
        act: (bloc) async {
          bloc.add(CounterEvent.increment);
          await Future.delayed(Duration(milliseconds: 10));
          bloc.add(CounterEvent.increment);
        },
        expect: [0, 1, 2],
      );
    });

    group('AsyncCounterBloc', () {
      blocTest(
        'emits [0] when nothing is added',
        build: () async => AsyncCounterBloc(),
        expect: [0],
      );

      blocTest(
        'emits [0, 1] when AsyncCounterEvent.increment is added',
        build: () async => AsyncCounterBloc(),
        act: (bloc) => bloc.add(AsyncCounterEvent.increment),
        expect: [0, 1],
      );

      blocTest(
        'emits [0, 1, 2] when AsyncCounterEvent.increment is called multiple'
        'times with async act',
        build: () async => AsyncCounterBloc(),
        act: (bloc) async {
          bloc.add(AsyncCounterEvent.increment);
          await Future.delayed(Duration(milliseconds: 10));
          bloc.add(AsyncCounterEvent.increment);
        },
        expect: [0, 1, 2],
      );
    });

    group('DebounceCounterBloc', () {
      blocTest(
        'emits [0] when nothing is added',
        build: () async => DebounceCounterBloc(),
        expect: [0],
      );

      blocTest(
        'emits [0, 1] when DebounceCounterEvent.increment is added',
        build: () async => DebounceCounterBloc(),
        act: (bloc) => bloc.add(DebounceCounterEvent.increment),
        wait: const Duration(milliseconds: 300),
        expect: [0, 1],
      );
    });

    group('MultiCounterBloc', () {
      blocTest(
        'emits [0] when nothing is added',
        build: () async => MultiCounterBloc(),
        expect: [0],
      );

      blocTest(
        'emits [0, 1, 2] when MultiCounterEvent.increment is added',
        build: () async => MultiCounterBloc(),
        act: (bloc) => bloc.add(MultiCounterEvent.increment),
        expect: [0, 1, 2],
      );

      blocTest(
        'emits [0, 1, 2, 3, 4] when MultiCounterEvent.increment is called'
        'multiple times with async act',
        build: () async => MultiCounterBloc(),
        act: (bloc) async {
          bloc.add(MultiCounterEvent.increment);
          await Future.delayed(Duration(milliseconds: 10));
          bloc.add(MultiCounterEvent.increment);
        },
        expect: [0, 1, 2, 3, 4],
      );
    });

    group('ComplexBloc', () {
      blocTest(
        'emits [ComplexStateA] when nothing is added',
        build: () async => ComplexBloc(),
        expect: [isA<ComplexStateA>()],
      );

      blocTest(
        'emits [ComplexStateA, ComplexStateB] when ComplexEventB is added',
        build: () async => ComplexBloc(),
        act: (bloc) => bloc.add(ComplexEventB()),
        expect: [isA<ComplexStateA>(), isA<ComplexStateB>()],
      );
    });

    group('SideEffectCounterBloc', () {
      Repository repository;

      setUp(() {
        repository = MockRepository();
      });

      blocTest(
        'emits [0] when nothing is added',
        build: () async => SideEffectCounterBloc(repository),
        expect: [0],
      );

      blocTest(
        'emits [0, 1] when SideEffectCounterEvent.increment is added',
        build: () async => SideEffectCounterBloc(repository),
        act: (bloc) => bloc.add(SideEffectCounterEvent.increment),
        expect: [0, 1],
        verify: (_) async {
          verify(repository.sideEffect()).called(1);
        },
      );
    });
  });
}
