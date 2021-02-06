#include <iostream>
//#include <windows.h>
#include <ctime>

extern "C" int fullChar (unsigned char*);
extern "C" int fullCharToString(unsigned char*, int);
extern "C" int addFullChars (unsigned char*, int, unsigned char*, int, unsigned char*);
extern "C" int absFullChars (unsigned char*, int, unsigned char*, int, unsigned char*);
extern "C" int divFullChars (unsigned char*, int, unsigned char*, int, unsigned char*);
extern "C" int removezeros (unsigned char*, int);
extern "C" int mulFullChars (unsigned char*, int, unsigned char*, int, unsigned char*);
extern "C" int andFullChars (unsigned char*, int, unsigned char*, int);

int get_prime(unsigned char* n, int n_len, unsigned char* d);
int randX(unsigned char* x, const unsigned char* n, int n_len);
int randC(unsigned char* c, const unsigned char* n, int n_len);
int copy(const unsigned char* x, int x_size, unsigned char* y);
int f(unsigned char* x, int x_len, unsigned char* c, int c_len, unsigned char* n, int n_len);
int GCD(unsigned char* a, int size_a, unsigned char* b, int size_b, unsigned char* gdc);
int EuclideanAlgorithm(unsigned char* a, int size_a, unsigned char* b, int size_b, unsigned char* gdc);
bool priorityTest(unsigned char* a, int size_a);
int MulMod(unsigned char* a, int size_a, unsigned char* b, int size_b, unsigned char* c, int size_c, unsigned char* w);
int PowMod(unsigned char* e, int size_e, unsigned char* u, int size_u, unsigned char* w);

//long long int read_QPC() {
//    LARGE_INTEGER count;
//    QueryPerformanceCounter(&count);
//    return((long long int)count.QuadPart);
//}

int main() {
//    long long int frequency, start, end, elapsed, tim;
//    QueryPerformanceFrequency((LARGE_INTEGER *)&frequency);

    /* initialize random seed */
    srand (time(nullptr));
    auto *number = new unsigned char[200];
    auto *prime = new unsigned char[150];
    auto *c = new unsigned char[200];
    int k = 0;

    printf("Wpisz liczbe: ");
    scanf("%s", number);

//    start = read_QPC();
    int num_len = fullChar(number);

    unsigned char two = 2;
    while (number[num_len - 1] % 2 == 0) {
        num_len = divFullChars(&two, 1, number, num_len, c);
        for (int i = 0; i < num_len; ++i)
            number[i] = c[i];
        if (number[0] == 0)
            num_len = removezeros(number, num_len);
        printf("%d ", 2);
    }

    while (!(number[0] == 1 && num_len == 1)) {
        if (!priorityTest(number, num_len)) {
            int size_p = get_prime(number, num_len, prime);
            for (int i = 0; i < num_len; ++i)
                c[i] = number[i];
            num_len = divFullChars(prime, size_p, c, num_len, number);
            num_len = removezeros(number, num_len);
                fullCharToString(prime, size_p);
                printf("%s ", prime);
        } else {
                fullCharToString(number, num_len);
                printf("%s ", number);
            break;
        }
    }
//    end = read_QPC();
//    elapsed = end - start;
//    tim = (1000000 * elapsed) / frequency;

    delete [] prime;
    delete [] number;
    printf("\n");
    system("pause");
    return 0;
}

/// Algorytm Rho Pollarda
int get_prime(unsigned char* n, int n_len, unsigned char* d)
{

    //    long long int x = (rand()%(n-2)) + 2;
    auto *x = new unsigned char [n_len];
    int x_len = randX(x, n, n_len);

    //    long long int y = x;
    auto *y = new unsigned char [n_len];
    int y_len = copy(x, x_len, y);

    //    long long int c = (rand()%(n - 1)) + 1;
    auto *c = new unsigned char [n_len];
    int c_len = randC(c, n, n_len);

    //    long long int d = 1;
    d[0] = 1;
    int d_len = 1;

    auto* pom = new unsigned char[n_len];
    auto n_copy = new unsigned char[n_len];

    bool keep_looking = true;
    while( keep_looking)
    {
        //        x = (f(x) + c + n) % n;
        x_len = f (x, x_len, c, c_len, n, n_len);

        //        y = (f((f(y) + c + n ) % n) + c + n) % n;
        y_len = f(y, y_len, c, c_len, n, n_len);
        y_len = f(y, y_len, c, c_len, n, n_len);

        //        d = GCD( llabs(x - y), number);
        int size = absFullChars(x, x_len, y, y_len, pom);
        copy(n, n_len, n_copy);
        d_len = GCD(pom, size, n_copy, n_len, d);
        keep_looking = d[0] == 1 && d_len == 1;
    }

    delete [] n_copy;
    delete [] c;
    delete [] x;
    delete [] y;

    if(n_len == d_len){
        int size = absFullChars(n, n_len, d, d_len, pom);
        if(size == 1 && pom[0] == 0)
            if(priorityTest(n, n_len)){
                delete [] pom;
                return 0;
            }
    }
    delete [] pom;

    if(!priorityTest(d, d_len))
    {
        auto *d_next = new unsigned char [d_len];
        d_len = get_prime(d, d_len, d_next);
        for (int i = 0; i < d_len; ++i)
            d[i] = d_next[i];
        delete [] d_next;
    }

    return d_len;
}

/// Funkcja generująca liczbę x
int randX(unsigned char* x, const unsigned char* n, int n_len){
    int range = rand() % n_len + 1;
    for(int i = 0; i < range; i++)
        x[i] = rand()%256;
    // Jeśli długość x jest równa długości n to x może być
    //      większe od n więc trzeba wykonać dzielenie modulo
    if(range == n_len)
    {
        unsigned char * a;
        unsigned char * b;
        a = new unsigned char[n_len];
        b = new unsigned char[n_len];
        for(int i = 0; i < n_len - 1; i++)
            a[i] = n[i];
        if(a[n_len - 1] == 1 || a[n_len - 1] == 0){
            for (int j = n_len - 2; j >= 0; --j)
                if(a[j] == 0)
                    a[j]--;
                else {
                    a[j]--;
                    break;
                }
        }
        a[n_len - 1] = n[n_len - 1] - 2;
        divFullChars(a, n_len, x, range, b);
        range = removezeros(x, n_len);
        if(x[range - 1] == 255 || x[range - 1] == 254){
            for (int j = range-2; j >= 0; --j)
                if(x[j] == 255)
                    a[j]++;
                else {
                    a[j]++;
                    break;
                }
        }
        x[range-1] += 2;
        delete [] a;
        delete [] b;
    }
    return range;
}

/// Funkcja kopiująca daną liczbę
int copy(const unsigned char* x, int x_size, unsigned char* y)
{
    for (int i = 0; i < x_size; ++i)
        y[i] = x[i];
    return x_size;
}

/// Funkcja generująca stałą c
int randC(unsigned char* c, const unsigned char* n, int n_len){
    int range = rand() % n_len + 1;
    for(int i = 0; i < range; i++)
        c[i] = rand() % 256;
    // Jeśli długość c jest równa długości n to x może być
    //      większe od n więc trzeba wykonać dzielenie modulo
    if(range == n_len)
    {
        unsigned char * a;
        unsigned char * b;
        a = new unsigned char[n_len];
        b = new unsigned char[n_len];
        for(int i = 0; i < n_len - 1; i++)
            a[i] = n[i];
        if(a[n_len-1] == 0)
            for (int j = n_len-2; j >= 0; --j)
                if (a[j] == 0) a[j]--;
                else {
                    a[j]--;
                    break;
                }
        a[n_len - 1] = n[n_len - 1] - 1;
        divFullChars(a, n_len, c, n_len, b);
        range = removezeros(c, n_len);
        if(c[range - 1] == 255)
            for (int j = range - 2; j >= 0; --j)
                if (c[j] != 255) {
                    a[j]++;
                    break;
                } else a[j]++;
        c[range-1] += 1;
        delete [] a;
        delete [] b;
    }

    return range;
}

/// Funkcja wyliczająca największy wspólny dzielnik
int GCD(unsigned char* a, int size_a, unsigned char* b, int size_b, unsigned char* gdc) {
    return EuclideanAlgorithm(a, size_a, b, size_b, gdc);
}

/// Funkcja pseudolosowa f(x) = x*x + c mod (n)
int f(unsigned char* x, int x_len, unsigned char* c, int c_len, unsigned char* n, int n_len)
{
    int size_sqrX = (x_len + x_len +  1) > c_len ? x_len + x_len +  1 : c_len + 1;
    auto * sqr_x = new unsigned char[size_sqrX];
    auto * d = new unsigned char[size_sqrX];
    size_sqrX = mulFullChars(x, x_len, x, x_len, sqr_x);
    size_sqrX = addFullChars(sqr_x, size_sqrX, c, c_len, sqr_x);
    divFullChars(n, n_len, sqr_x, size_sqrX, d);
    size_sqrX = removezeros(sqr_x, size_sqrX);
    for (int i = 0; i < size_sqrX; ++i)
        x[i] = sqr_x[i];
    delete [] sqr_x;
    delete [] d;
    return size_sqrX;
}

//// Algorytm Euklidesa
int EuclideanAlgorithm(unsigned char* a, int size_a, unsigned char* b, int size_b, unsigned char* gdc){
    bool keep_looking = true;
    int size = size_a > size_b ? size_a : size_b;
    auto d = new unsigned char[size];
    while (keep_looking){
        copy(b, size_b, gdc);
        divFullChars( b, size_b, a, size_a, d);
        size_a = removezeros(a, size_a);
        for(int i = 0; i < size_a; i++)
            b[i] = a[i];
        size = size_b;
        size_b = size_a;
        for(int i = 0; i < size; i++)
            a[i] = gdc[i];
        size_a = size;
        keep_looking = !(b[0] == 0 && size_b == 1);
    }
    delete [] d;
    return size;
}

//// Test pierwszości - Chiński test pierwszości
bool priorityTest(unsigned char* a, int size_a) {
    if(a[0] == 2 && size_a == 1)
        return true;
    auto c = new unsigned char[size_a+size_a];
    int size_c = PowMod(a, size_a, a, size_a, c);
    bool isPriority = false;
    if( c[0] == 2 && size_c == 1)
        isPriority = true;
    delete [] c;
    return isPriority;
}

//// Funkcja mnoży a i b mod n
int MulMod(unsigned char* a, int size_a, unsigned char* b, int size_b, unsigned char* c, int size_c, unsigned char* w)
{
    // Tablice pomocnicze
    auto pom = new unsigned char[size_c+1];
    auto mask = new unsigned char[size_b];
    unsigned char two = 2;

    int mask_len = 1;
    int size_w = 1;
    mask[0] = 1;
    w[0] = 0;
    for (int j = 0; j < size_b*8; ++j)
    {
        if(andFullChars(mask, mask_len, b, size_b))
        {
            int size = addFullChars(a, size_a, w, size_w, w);
            divFullChars(c, size_c, w, size, pom);
            size_w = removezeros(w, size);
        }
        pom[0] = 1;
        if(j == size_b*8 - 1)
            break;

        size_a = mulFullChars(&two, 1, a, size_a, pom);
        int l = pom[0] == 0 ? 1 : 0;
        if(l == 1) size_a--;
        for (int i = 0; i < size_a; ++i, ++l)
            a[i] = pom[l];
        divFullChars(c, size_c, a, size_a, pom);

        size_a = removezeros(a, size_a);
        mask_len = mulFullChars(&two, 1, mask, mask_len, pom);
        int k = pom[0] == 0 ? 1 : 0;
        if(k == 1) mask_len--;
        for (int i = 0; i < mask_len; ++i, ++k)
            mask[i] = pom[k];
    }
    delete [] mask;
    delete [] pom;
    return size_w;
}

//// Funkcja oblicza 2^e mod n
int PowMod(unsigned char* e, int size_e, unsigned char* u, int size_u, unsigned char* w)
{
    // Tablice pomocnicze
    auto m = new unsigned char[size_e];
    auto p = new unsigned char[size_e];
    auto p2 = new unsigned char[size_e+size_e];
    auto pom = new unsigned char[size_e+size_e];
    unsigned char two = 2;

    int size_m = 1, size_p = 1, size_w = 1;
    p[0] = 2; w[0] = m[0] = 1;

    for (int j = 0; j < size_e*8; ++j)
    {
        if(andFullChars(e, size_e, m, size_m))
        {
            size_w = MulMod(w, size_w, p, size_p, u, size_u, pom);
            for (int i = 0; i < size_w; ++i)
                w[i] = pom[i];
        }
        for (int i = 0; i < size_p; ++i)
            p2[i] = p[i];
        size_p = MulMod(p2, size_p, p, size_p, u, size_u, pom);
        for (int i = 0; i < size_p; ++i)
            p[i] = pom[i];

        if(j == size_e*8 - 1)
            break;

        size_m = mulFullChars(&two, 1, m, size_m, pom);
        int k = pom[0] == 0 ? 1 : 0;
        if(k == 1) size_m--;
        for (int i = 0; i < size_m; ++i, ++k)
            m[i] = pom[k];
    }
    delete [] m;
    delete [] p;
    delete [] p2;
    delete [] pom;
    return size_w;
}
