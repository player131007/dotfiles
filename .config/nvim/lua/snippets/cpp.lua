return {
    s(
        "cp",
        fmt(
            [=[
            #include "bits/stdc++.h"

            using namespace std;

            template<typename T>
            bool maximize(T &a, const T &b) {
                return a<b && (a=b, true);
            }
            template<typename T>
            bool minimize(T &a, const T &b) {
                return a>b && (a=b, true);
            }

            namespace detail {
                template<typename It>
                struct rge { It b,e; };

                template<typename It>
                rge<It> r(It b, It e) { return rge<It>{b,e}; }

                string tab;
                struct db {
                    #ifdef LOCAL
                    db() { tab.push_back('\t'); }
                    ~db() { tab.pop_back(); }
                    #endif
                };
            }

            template<typename T1, typename T2>
            ostream& operator<<(ostream &os, const pair<T1, T2> &p);

            template<typename It>
            ostream& operator<<(ostream &os, detail::rge<It> r) {
                os << '{' << *r.b;
                for(++r.b; r.b!=r.e; ++r.b) os << ", " << *r.b;
                return os << '}';
            }

            template<typename Cont, typename = typename enable_if<!is_same<Cont,string>{}>::type>
            auto operator<<(ostream &os, const Cont &c) -> decltype(c.begin(), c.end(), declval<ostream&>()) {
                return os << detail::r(c.begin(), c.end());
            }

            template<typename T1, typename T2>
            ostream& operator<<(ostream &os, const pair<T1, T2> &p) {
                return os << '(' << p.first << ", " << p.second << ')';
            }

            #define dbc(a,v) "[["#a": " << v << "]] "
            #define dbg(a) dbc(a,a)
            #define dbr(a,b,e) dbc(a, detail::r(next(begin(a),b),next(begin(a),e+1)))
            #ifdef LOCAL
            #define cerr cerr << detail::tab
            #else
            #define cerr if(0) cerr
            #endif

            #define ll long long

            []

            signed main() {
                ios::sync_with_stdio(false);
                cin.tie(NULL);

                if(fopen("[].inp","r")) {
                    freopen("[].inp","r",stdin);
                    freopen("[].out","w",stdout);
                }

                []
            }
            ]=],
            {
                i(2),
                d(1,function(_, snip)
                        return sn(nil, {i(1,snip.env.TM_FILENAME_BASE)}) 
                    end
                ),
                rep(1),
                rep(1),
                i(0)
            },
            {delimiters = "[]"}
        )
    )
}
