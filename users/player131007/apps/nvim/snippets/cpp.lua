return {
s(
    {
        trig = "cp",
        name = "cp",
        desc = "Competitive programming template"
    },
    fmt(
        [=[
            #include "bits/stdc++.h"

            using namespace std;

            template<typename T>
            bool maximize(T &a, const T &b) { return b>a && (a=b, true); }

            template<typename T>
            bool minimize(T &a, const T &b) { return b<a && (a=b, true); }

            template<typename It>
            struct _rge {
                It b, e;
                friend ostream &operator<<(ostream &os, const _rge<It> &r) {
                    if (r.b == r.e) return os << "{}";
                    os << '{' << *r.b;
                    for (It i = next(r.b); i != r.e; ++i) os << ", " << *i;
                    return os << '}';
                }
            };

            namespace std {
                // put these in std so that we have ADL
                template <typename T1, typename T2>
                ostream &operator<<(ostream &os, const pair<T1, T2> &p) {
                return os << '(' << p.first << ", " << p.second << ')';
                }

                template<typename Cont, typename It = decltype(begin(declval<Cont>()))>
                enable_if_t<!is_same<Cont, string>{}, ostream&> operator<<(ostream &os, const Cont &c) {
                    return os << _rge<It>{begin(c), end(c)};
                }
            }

            int _depth = 0;
            struct _db {
                _db() { ++_depth; }
                ~_db() { --_depth; }
            };

            #define dbg(a) "[["#a": " << (a) << "]] "
            #define dbr(a, b, e) "[["#a"[[" << (b) << ".." << (e) << "]]: " << _rge<decltype(begin(a))>{next(begin(a), b), next(begin(a), e+1)} << "]] "
            #ifdef LOCAL
            #define cerr cerr << setw(2*_depth) << "" << setw(0)
            #else
            #define cerr if(0) cerr
            #endif

            #define ll long long
            #define fi first
            #define se second

            [2]

            int main() {
                ios::sync_with_stdio(false);
                cin.tie(NULL);

                if(fopen("[1].inp", "r")) {
                    freopen("[1].inp", "r", stdin);
                    #ifndef LOCAL
                    freopen("[1].out", "w", stdout);
                    #endif
                }

                [3]
            }
        ]=],
        {
            i(1, vim.fn.expand("%:t:r")),
            i(2),
            i(0)
        },
        {
            delimiters = "[]",
            repeat_duplicates = true
        }
    )
)
}
