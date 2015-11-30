---
title: MockStaticAndComplexObjects
category: unit-testing-utilities
authors: kianku
wiki_category: Unit Testing Utilities
wiki_title: MockStaticAndComplexObjects
wiki_revision_count: 1
wiki_last_updated: 2014-02-25
---

# Mocking Static Objects

Let say you have a Class you want to test, Class A. A uses a static reference in it methods

    class a {
        public void func() {
            StaticObject.doLogic();
        }
    }

In cases you want to mock the behavior of the `StaticObject.doLogic()` method, you we need to have access to the static object, usually by a getter. This should be done before writing the jUnit tests, while you code. In our example:

    class a {
        public void func() {
            getStaticObject().doLogic();
        }

        public StaticObject getStaticObject() {
            return StaticObject;
        }
    }

Now that you have an access method to the static object you mock the behavior of the `getStaticObject()` method, change it to return your mocked instance of the static object.

    @RunWith(MockitoJUnitRunner.class)
    class aTest {
        @mock
        StaticObject myStaticObject;

        @spy
        A a = new A();

        @Test
        public void doTest() {
            doReturn(myStaticObject).when(a).getStaticObject();
            ...
            ...
        }

    }

After you assign `myStaticObject` to replace the existitng static object, you can mock method as usual.

    doReturn("test123").when(myStaticObject)..doLogic();

*   note: due to performance issues it is not recomended to use PowerMockito.

# Mocking Complex Objects

Let's say you are testing Class A, who has a member Class B, who has a member Class C, and you want to mock one of the Class C's methods. There's no easy way to do that, just to walk through the hierarchy .

        @mock
        B b;

        @mock
        C c;

        @Test
        public void doTest() {
            doReturn(b).when(a).getB();
            doReturn(c).when(b).getC();
            doReturn("test123").when(c).doLogic();
            ...
            ...
        }

[Category:Unit Testing Utilities](Category:Unit Testing Utilities)
