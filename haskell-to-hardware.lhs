%% -*- latex -*-

%% %let atwork = True

% Presentation
\documentclass{beamer}
%% \documentclass[handout]{beamer}

%% % Printed, 2-up
%% \documentclass[serif,handout]{beamer}
%% \usepackage{pgfpages}
%% \pgfpagesuselayout{2 on 1}[border shrink=1mm]

%% % Printed, 4-up
%% \documentclass[serif,handout,landscape]{beamer}
%% \usepackage{pgfpages}
%% \pgfpagesuselayout{4 on 1}[border shrink=1mm]

\usefonttheme{serif}

\usepackage{hyperref}
\usepackage{color}

\definecolor{linkColor}{rgb}{0.62,0,0}

\hypersetup{colorlinks=true,urlcolor=linkColor}

%% \usepackage{beamerthemesplit}

%% % http://www.latex-community.org/forum/viewtopic.php?f=44&t=16603
%% \makeatletter
%% \def\verbatim{\small\@verbatim \frenchspacing\@vobeyspaces \@xverbatim}
%% \makeatother

\usepackage{graphicx}
\usepackage{color}
\DeclareGraphicsExtensions{.pdf,.png,.jpg}

%% \usepackage{wasysym}
\usepackage{mathabx}
\usepackage{setspace}
\usepackage{enumerate}

\useinnertheme[shadow]{rounded}
% \useoutertheme{default}
\useoutertheme{shadow}
\useoutertheme{infolines}
% Suppress navigation arrows
\setbeamertemplate{navigation symbols}{}

\input{macros}

%\nc\partframe[1]{\framet{}{\begin{center} \vspace{6ex} {\Huge #1} \end{center}}}
\nc\partframe[1]{\framet{}{\begin{center} \Huge \emph{\textcolor{blue}{#1}} \end{center}}}

%include polycode.fmt
%include forall.fmt
%include greek.fmt

%include mine.fmt

%% %% A subset of mine.fmt. Steve wanted more conventional looking code.
%% %format not = "\Varid{not}"
%% %format :# = "\mathbin{:\!\#}"
%% %format ~> = "\leadsto"
%% %format Prod (k) a b = a "\times_{\hspace{-0.1ex}\scriptscriptstyle{" k "}}" b
%% %format Coprod (k) a b = a "+_{\hspace{-0.4ex}\scriptscriptstyle{" k "}}" b
%% %format Exp (k) a b = a "\Rightarrow_{\hspace{-0.4ex}\scriptscriptstyle{" k "}}" b
%% %format *** = "\!\times\!"
%% %format &&& = "\mathbin{\smalltriangleup}"
%% %format ||| = "\mathbin{\smalltriangledown}"
%% %format +++ = "\!+\!"
%% %format N0 = 0
%% %format N1 = 1
%% %format N2 = 2
%% %format N3 = 3
%% %format N4 = 4
%% %format N5 = 5
%% %format N6 = 6
%% %format N7 = 7
%% %format N8 = 8
%% %% Tweaked
%% %format <$> = "\mathbin{<\!\!\$\!\!>}"
%% %format <.> = "\mathbin{<\!.\!>}"
%% %% hack: add missing space, e.g., before "{" in data type decl
%% %format SPACE = "\ {}"
%% %% Small space
%% %format SSPACE = "{}"
%% %format :=> = "\dashrightarrow"
%% \setbeamerfont{frametitle}{size=\small}

\title{From Haskell to Hardware via CCCs}
\author{\href{http://conal.net}{Conal Elliott}}
% \institute{Work done at \href{http://tabula.com/}{Tabula}}
% Abbreviate date/venue to fit in infolines space
\date{April, 2015}
% \date{\emph{Draft of \today}}

\setlength{\itemsep}{2ex}
\setlength{\parskip}{1ex}

% \setlength{\blanklineskip}{1.5ex}

\nc\pitem{\pause \item}

%%%%

% \setbeameroption{show notes} % un-comment to see the notes

\setstretch{1.2}

\begin{document}

\frame{\titlepage}

\framet{Tabula}{

\begin{itemize}\parskip0.75ex
\item Founded by Steve Teig about 11 years ago. Newly defunct. :(
\item Post-FPGA hardware architecture, \emph{Spacetime}:
  \begin{itemize}
  \item 3D for shorter paths.
  \item Implemented by rapid reconfiguration (2GHz).
  \item Dense \emph{active} logic.
  \end{itemize}
\item Program in a non-sequential language: Haskell.
\item Compiler \href{https://github.com/conal/lambda-ccc/}{developed openly} and shared freely.
\end{itemize}

}

\framet{Example}{

> square :: Num a => a -> a
> square a = a * a

> sumSquare :: (Functor f, Foldable f, Num a) => f a -> a
> sumSquare = sum . fmap square

}

\framet{|sumSquare :: RTree N2 Int -> Int|}{

\begin{center}
\begin{minipage}[c]{0.3\textwidth}\ \end{minipage}
\begin{minipage}[c]{0.5\textwidth}

> sumSquare = sum . fmap square

\end{minipage}
\end{center}

\vspace{-10ex}
\wfig{5in}{figures/sumSquare-t2}

}

\framet{|sumSquare :: RTree N2 Int -> Int|}{

\begin{minipage}[c]{0.0\textwidth}
{\tiny
\begin{verbatim}
module sumSquare-t2 (In_0, In_1, In_2, In_3, Out);
  input [0:31] In_0;
  input [0:31] In_1;
  input [0:31] In_2;
  input [0:31] In_3;
  output [0:31] Out;
  wire [0:31] w_mul_I1;
  wire [0:31] w_mul_I2;
  wire [0:31] w_mul_I3;
  wire [0:31] w_mul_I4;
  wire [0:31] w_add_I5;
  wire [0:31] w_add_I6;
  wire [0:31] w_add_I7;
  assign w_mul_I1 = In_0 * In_0;
  assign w_mul_I2 = In_1 * In_1;
  assign w_mul_I3 = In_2 * In_2;
  assign w_mul_I4 = In_3 * In_3;
  assign w_add_I5 = w_mul_I1 + w_mul_I2;
  assign w_add_I6 = w_mul_I3 + w_mul_I4;
  assign w_add_I7 = w_add_I5 + w_add_I6;
  assign Out = w_add_I7;
endmodule
\end{verbatim}
}
\end{minipage}
\hspace{-10ex}
\begin{minipage}[c]{0.5\textwidth}
\wfig{3in}{figures/sumSquare-t2}
\end{minipage}
}

\framet{|sumSquare :: RTree N3 Int -> Int|}{
\vspace{-2ex}
\wfig{4.5in}{figures/sumSquare-t3}
}

\framet{|sumSquare :: RTree N4 Int -> Int|}{
\vspace{-1ex}
\wfig{3in}{figures/sumSquare-t4}
}

\partframe{How it works}

\framet{Intuition: overloading lambda}{\parskip3ex

Powerful abstraction mechanisms:
\begin{itemize}\parskip1ex
\item Lambda/application
\item Type classes
\end{itemize}

\vspace{1ex}

Can we use type classes to generalize lambda \& application?

}

\framet{Technical plan}{

\begin{itemize}\parskip2ex
\item Convert Haskell to Core (GHC).
\item Monomorphize.
\item Convert to abstract vocabulary.
\item Interpret as circuits.
%% \item Translate to netlists.
\item Synthesize \& optimize with existing HDL machinery.
\end{itemize}

%if False
\vspace{2ex}

Initial simplifications:
\begin{itemize}
\item Shape-typed data
\item Combinational
\end{itemize}
%endif

}

\framet{(Bi-)Cartesian closed categories}{

\begin{itemize}\parskip2ex
\item
  \emph{Category}: identity and composition
\item
  \emph{Cartesian}: products
\item
  \emph{Co-Cartesian}: coproducts (``sums'')
\item
  \emph{Closed}: exponentials (arrows as ``values'')
\end{itemize}

\ 

Suffices for translating typed lambda calculus (J. Lambek, 1980).

}

\framet{Category}{

Interface:

> class Category (~>) where
>   id   :: a ~> a
>   (.)  :: (b ~> c) -> (a ~> b) -> (a ~> c)

Laws:

> id . f       == f
> g . id       == g
> (h . g) . f  == h . (g . f)

}

\setlength{\fboxsep}{-1ex}

\framet{Products}{

> class Category (~>) => ProductCat (~>) where
>   type Prod (~>) a b
>   exl      ::  (Prod (~>) a b) ~> a
>   exr      ::  (Prod (~>) a b) ~> b
>   (&&&)    ::  (a ~> c)  -> (a ~> d)  -> (a ~> (Prod (~>) c d))
>   (***)    ::  (a ~> c)  -> (b ~> d)  -> ((Prod (~>) a b) ~> (Prod (~>) c d))
>   f *** g  =   (f . exl ) &&& (g . exr)

Laws:
\vspace{-1.3ex}

\begin{center}
\fbox{\begin{minipage}[c]{0.41\textwidth}

> exl . (f &&& g)      == f                
> exr . (f &&& g)      == g                
> exl . h &&& exr . h  == h                
> exl &&& exr          == id               

\end{minipage}}
\fbox{\begin{minipage}[c]{0.6\textwidth}

> (f *** g) . (h &&& k)  == (f . h) &&& (g . k)     
> id *** id              == id               
> (f *** g) . (h *** k)  == (f . h) *** (g . k)     
> (f &&& g) . h          == (f . h) &&& (g . h)

\end{minipage}}
\end{center}

}

\framet{Coproducts}{

> class Category (~>) => CoproductCat (~>) where
>   type Coprod (~>) a b
>   inl      ::  a ~> (Coprod (~>) a b)
>   inr      ::  b ~> (Coprod (~>) a b)
>   (|||)    ::  (a ~> c)  -> (b ~> c)  -> ((Coprod (~>) a b) ~> c)
>   (+++)    ::  (a ~> c)  -> (b ~> d)  -> ((Coprod (~>) a b) ~> (Coprod (~>) c d))
>   f +++ g  =   (inl . f ) ||| (inr . g)

Laws (dual to product):
\vspace{-1.7ex}

\begin{center}
\fbox{\begin{minipage}[c]{0.41\textwidth}

> (f ||| g) . inl      == f
> (f ||| g) . inr      == g
> h . inl ||| h . inr  == h
> inl ||| inr          == id

\end{minipage}}
\fbox{\begin{minipage}[c]{0.6\textwidth}

> (h ||| k) . (f +++ g)  == (h . f) ||| (k . g)     
> id +++ id              == id               
> (h +++ k) . (f +++ g)  == (h . f) +++ (k . g)     
> h . (f ||| g)          == (h . f) ||| (h . g)

\end{minipage}}
\end{center}
}

\framet{Exponentials}{

> class ProductCat (~>) => ClosedCat (~>) where
>   type Exp (~>) a b
>   apply    :: (Prod (~>) (Exp (~>) a b) a) ~> b
>   curry    :: ((Prod (~>) a b) ~> c) -> (a ~> (Exp (~>) b c))
>   uncurry  :: (a ~> (Exp (~>) b c)) -> ((Prod (~>) a b) ~> c)

}

\framet{GHC Core}{

\pause

> data Expr b	-- ``b'' for the type of binders, 
>   =  Var   Id
>   |  Lit   Literal
>   |  App   (Expr b) (Expr b)
>   |  Lam   b (Expr b)
>   |  Let   (Bind b) (Expr b)
>   |  Case  (Expr b) b Type [Alt b]
>   |  Cast  (Expr b) Coercion
>   |  Type  Type
> 
> type Alt b = (AltCon, [b], Expr b)
> 
> data AltCon = DataAlt DataCon | LitAlt  Literal | DEFAULT
> 
> data Bind b = NonRec b (Expr b) | Rec [(b, Expr b)]

}

\framet{Lambda term GADT}{

> data E :: * -> * SPACE where
>   Var    :: V a -> E a
>   Const  :: Prim a -> E a
>   App    :: E (a -> b) -> E a -> E b
>   Lam    :: Pat a -> E b -> E (a -> b)

> data Pat :: * -> * SPACE where
>   UnitPat  :: Pat Unit
>   VarPat   :: V a -> Pat a
>   PairPat  :: Pat a -> Pat b -> Pat (a :* b)

}

\framet{Lambda to CCC}{

> (\ p -> k)         :=>  const k
> (\ p -> v)         :=>  ...      -- accessor
> (\ p -> u v)       :=>  apply . ((\ p -> u) &&& (\ p -> v))
> (\ p -> \ q -> u)  :=>  curry (\ (p,q) -> u)

\pause

> convert ::  CCC (~>) => Pat a -> E b -> (a ~> b)
> convert _  (Const x)   = constArrow x
> convert p  (Var v)     = convertVar p v
> convert p  (App u v)   = apply . (convert p u &&& convert p v)
> convert p  (Lam q e)   = curry (convert (PairPat p q) e)

%% \hrefc{https://github.com/ku-fpg/lambda-ccc/blob/master/src/LambdaCCC/ToCCC.hs}{source}

}

\framet{Circuit CCC}{

> data Comp = forall a b. Comp (Prim a b) (Buses a) (Buses b)
>
> type CircuitM = WriterT (Seq Comp) (State BusSupply)

> newtype a :> b = Circ (Buses a -> CircuitM (Buses b))

> instance Category      (:>) where ...
> instance ProductCat    (:>) where ...
> instance ClosedCat     (:>) where ...

}

\partframe{Examples}

%if False
\framet{|sumSquare :: RTree N2 Int -> Int|}{

\begin{center}
\begin{minipage}[c]{0.3\textwidth}\ \end{minipage}
\begin{minipage}[c]{0.5\textwidth}

> sumSquare = sum . fmap square

\end{minipage}
\end{center}

\vspace{-10ex}
\wfig{5in}{figures/sumSquare-t2}

}
%endif

\framet{|sumSquare :: RTree N2 Int -> Int|}{

\pause

\begin{center}
{\tiny
\begin{verbatim}

uncurry (apply . (curry (apply . (curry (apply . (curry (apply . (curry (curry
(apply . (curry (apply . (apply . (curry (curry (uncurry add) . exr) . it &&&
apply . (curry (repr . exr) . it &&& apply . (((((id . exr) . exl) . exl) . exl)
. id *** (id . exl) . id))) &&& apply . (curry (repr . exr) . it &&& apply .
(((((id . exr) . exl) . exl) . exl) . id *** (id . exr) . id)))) &&& apply .
(curry (repr . exr) . it &&& apply . (curry (apply . (curry (abst . exr) . it
&&& apply . (apply . (curry (curry id . exr) . it &&& apply . (((id . exr) .
exl) . id *** (id . exl) . id)) &&& apply . (((id . exr) . exl) . id *** (id .
exr) . id)))) &&& apply . (curry (repr . exr) . it &&& apply . (curry (repr .
exr) . it &&& id . exr))))))) &&& curry (apply . (curry (abst . exr) . it &&&
apply . (curry (apply . (curry (abst . exr) . it &&& apply . (apply . (curry
(curry id . exr) . it &&& apply . (((id . exr) . exl) . id *** (id . exl) . id))
&&& apply . (((id . exr) . exl) . id *** (id . exr) . id)))) &&& apply . (curry
(repr . exr) . it &&& apply . (curry (repr . exr) . it &&& id . exr))))))) &&&
curry (apply . (curry (apply . (curry (abst . exr) . it &&& apply . (apply .
(curry (curry (uncurry mul) . exr) . it &&& id . exr) &&& id . exr))) &&& apply
. (curry (repr . exr) . it &&& id . exr))))) &&& curry (apply . (curry (apply .
(curry (abst . exr) . it &&& apply . (apply . (curry (curry (uncurry add) . exr)
. it &&& apply . (curry (repr . exr) . it &&& apply . (((id . exr) . exl) . id
*** (id . exl) . id))) &&& apply . (curry (repr . exr) . it &&& apply . (((id .
exr) . exl) . id *** (id . exr) . id))))) &&& apply . (curry (repr . exr) . it
&&& apply . (curry (repr . exr) . it &&& id . exr)))))) &&& curry (apply .
(curry (abst . exr) . it &&& apply . (curry (repr . exr) . it &&& id . exr)))))
. (it &&& id)

\end{verbatim}
}
\end{center}
}

\framet{|sumSquare :: RTree N2 Int -> Int|}{

\begin{minipage}[c]{0.0\textwidth}
{\tiny
\begin{verbatim}
module sumSquare-t2 (In_0, In_1, In_2, In_3, Out);
  input [0:31] In_0;
  input [0:31] In_1;
  input [0:31] In_2;
  input [0:31] In_3;
  output [0:31] Out;
  wire [0:31] w_mul_I1;
  wire [0:31] w_mul_I2;
  wire [0:31] w_mul_I3;
  wire [0:31] w_mul_I4;
  wire [0:31] w_add_I5;
  wire [0:31] w_add_I6;
  wire [0:31] w_add_I7;
  assign w_mul_I1 = In_0 * In_0;
  assign w_mul_I2 = In_1 * In_1;
  assign w_mul_I3 = In_2 * In_2;
  assign w_mul_I4 = In_3 * In_3;
  assign w_add_I5 = w_mul_I1 + w_mul_I2;
  assign w_add_I6 = w_mul_I3 + w_mul_I4;
  assign w_add_I7 = w_add_I5 + w_add_I6;
  assign Out = w_add_I7;
endmodule
\end{verbatim}
}
\end{minipage}
\hspace{-10ex}
\begin{minipage}[c]{0.5\textwidth}
\wfig{3in}{figures/sumSquare-t2}
\end{minipage}
}

%if False
\framet{|\ (a,b) -> a+b :: Int|}{\parskip3ex

\begin{center}
\begin{minipage}[c]{0.45\textwidth}
\wfig{2.3in}{figures/sum-2}
\end{minipage}
\begin{minipage}[c]{1\textwidth}

{\small
\begin{verbatim}
module sum-2 (In_0, In_1, Out);
  input [0:31] In_0;
  input [0:31] In_1;
  output [0:31] Out;
  wire [0:31] w_add_I1;
  assign w_add_I1 = In_0 + In_1;
  assign Out = w_add_I1;
endmodule
\end{verbatim}
}
\end{minipage}
\end{center}
}
%endif

%if False

\framet{|\ (a,b,c,d) -> a+b+c+d :: Int|}{
\vspace{-1ex}
\wfig{3.45in}{figures/sum-4a}
}

\framet{|\ (a,b,c,d) -> (a+b)+(c+d) :: Int|}{
%\vspace{-2ex}
\wfig{3.75in}{figures/sum-4b}
}

%endif

\framet{Uniform pairs}{

\vspace{8ex}

> data Pair a = a :# a

\vspace{8ex}

|Functor|, |Applicative|, |Monad|, |Foldable|, |Traversable|.

}

\framet{|sum :: Pair Int -> Int|}{
\wfig{4in}{figures/sum-p}
}

\framet{|sumSquare :: Pair Int -> Int|}{
%\vspace{-2ex}
\wfig{4in}{figures/sumSquare-p}
}

\framet{Length-typed vectors}{

> data VecTy :: Nat -> * -> * SPACE where
>   ZVec  :: Vec Z a 
>   (:<)  :: a -> Vec n a -> Vec (S n) a

\pause
\vspace{-5ex}

> instance Functor (Vec n) where
>   fmap _ ZVec      = ZVec
>   fmap f (a :< u)  = f a :< fmap f u
>
> instance Foldable (Vec n) where
>   foldMap _ ZVec       = mempty
>   foldMap h (a :< as)  = h a <> foldMap h as

And |Applicative|, |Monad|, |Traversable|.

}

\framet{|fmap not :: Vec N6 Bool -> Vec N6 Bool|}{
\vspace{-4.2ex}
\wfig{3in}{figures/map-v6}
}

\framet{|sum :: Vec N6 Int -> Int|}{
\vspace{-1ex}
\wfig{4.8in}{figures/sum-v6-0}
}

\framet{|sum :: Vec N6 Int -> Int| --- optimized}{
\vspace{-1ex}
\wfig{4.8in}{figures/sum-v6}
}

\framet{Depth-typed trees (top-down)}{

> data RTreeTy :: Nat -> * -> * SPACE where
>   L  :: a -> RTree Z a
>   B  :: Pair (RTree n a) -> RTree (S n) a

\pause
\vspace{-5ex}

> instance Functor (RTree n) where
>   fmap f (L a   ) = L (f a)
>   fmap f (B ts  ) = B ((fmap.fmap) f ts)
>
> instance Foldable (RTree n) where
>   foldMap f (L a   ) = f a
>   foldMap f (B ts  ) = (foldMap.foldMap) f ts

And |Applicative|, |Monad|, |Traversable|.

Easily generalize beyond |Pair|.

}

\framet{Depth-typed trees (bottom-up)}{

> data LTreeTy :: Nat -> * -> * SPACE where
>   L  :: a -> LTree Z a
>   B  :: LTree n (Pair a) -> LTree (S n) a

% \pause
\vspace{-5ex}

> instance Functor (LTree n) where
>   fmap f (L a   ) = L (f a)
>   fmap f (B ts  ) = B ((fmap.fmap) f ts)
>
> instance Foldable (LTree n) where
>   foldMap f (L a   ) = f a
>   foldMap f (B ts  ) = (foldMap.foldMap) f ts

And |Applicative|, |Monad|, |Traversable|.

Easily generalize beyond |Pair|.

}

\framet{|fmap not :: RTree N3 Bool -> RTree N3 Bool|}{
\vspace{-3.5ex}
\wfig{2.3in}{figures/map-t3}
}

\framet{|sum :: RTree N4 Int -> Int|}{
\vspace{-2ex}
\wfig{3.6in}{figures/sum-t4}
}

\framet{|sum :: RTree N3 Int -> Int|}{

\vspace{-1ex}
Monomorphized \& simplified GHC Core:

{\tiny

> let  f0 :: RTree N0 Int -> Sum Int
>      f0 = \ ds ->
>        abst ZfRepSum (repr ZfRepTree0 ds)
>      f1 :: RTree N1 Int -> Sum Int
>      f1 = \ ds ->
>        case repr ZfRepPair (repr ZfRepTree ds) of
>          (,) a b ->
>            abst ZfRepSum
>                 (ZfNumInt_ZcP  (repr ZfRepSum (f0 a))
>                                (repr ZfRepSum (f0 b)))
>      f2 :: RTree N2 Int -> Sum Int
>      f2 = \ ds ->
>        case repr ZfRepPair (repr ZfRepTree ds) of
>          (,) a b ->
>            abst ZfRepSum
>                 (ZfNumInt_ZcP  (repr ZfRepSum (f1 a))
>                                (repr ZfRepSum (f1 b)))
> in SPACE \ eta ->
>       repr ZfRepSum
>            (case repr ZfRepPair (repr ZfRepTree eta) of
>               (,) a b ->
>                 abst ZfRepSum
>                      (ZfNumInt_ZcP  (repr ZfRepSum (f2 a))
>                                     (repr ZfRepSum (f2 b))))

}
}

\framet{Dot products}{

> dot ::  (Traversable g, Foldable f, Applicative f, Num a) =>
>         g (f a) -> a
> dot = sum . fmap product . transpose

where

> transpose :: (Traversable g, Applicative f) => g (f a) -> f (g a)

also called |sequenceA| from |Traversable|.

For |dot|, typically |g == Pair|.

}

\framet{|transpose :: Pair (RTree N4 Int) -> RTree N4 (Pair Int)|}{
\vspace{-3ex}
\wfig{1.83in}{figures/transpose-pt4}
}

\framet{|transpose :: RTree N4 (Pair Int) -> Pair (RTree N4 Int)|}{
\vspace{-3ex}
\wfig{1.83in}{figures/transpose-t4p}
}

%if False
\framet{|dot :: Pair (RTree N1 Int) -> Int|}{
\vspace{-2ex}
\wfig{4.1in}{figures/dotsp-pt1}
}
%endif

\framet{|dot :: Pair (RTree N2 Int) -> Int|}{
\vspace{-2ex}
\wfig{4.8in}{figures/dotsp-pt2}
}

%if False

\framet{|dot :: Pair (RTree N3 Int) -> Int|}{
\vspace{-3ex}
\wfig{3.25in}{figures/dotsp-pt3}
}

\framet{|dot :: Pair (RTree N4 Int) -> Int|}{
\vspace{-2ex}
\wfig{3in}{figures/dotsp-pt4}
}

\framet{|dot :: Vec N3 (RTree N2 Int) -> Int|}{
\vspace{-3ex}
\wfig{3.3in}{figures/dotsp-v3t2}
}

\framet{|dot :: RTree N2 (RTree N2 Int) -> Int|}{
\vspace{-3ex}
\wfig{3.3in}{figures/dotsp-t2t2}
}

%endif

\framet{Linear transformations}{

> (<.>) :: (Foldable f, Num (f a), Num a) => f a -> f a -> a
> u <.> v = dot (u :# v)

\pause

> type Matrix m n a = Vec n (Vec m a)

> ($@) :: (IsNat m, Num a) => Matrix m n a -> Vec m a -> Vec n a
> mat $@ vec = (<.> vec) <$> mat

}

\framet{|($@) :: Matrix N2 N3 Int -> Vec N2 Int -> Vec N3 Int|}{
\vspace{-3ex}
\wfig{4in}{figures/applyLin-v23}
}

\framet{|($@) :: Matrix N4 N2 Int -> Vec N4 Int -> Vec N2 Int|}{
\vspace{-0ex}
\wfig{4.5in}{figures/applyLin-v42}
}

\framet{|Generalizing linear transformations|}{

> ($@) ::  (IsNat m, Num a) =>
>          Vec n (Vec m a) -> Vec m a -> Vec n a
> mat $@ vec = (<.> vec) <$> mat

More simply and generally,

> ($@) ::  (Foldable m, Applicative m, Functor n, Num a) =>
>          n (m a) -> m a -> n a

For instance,

> type MatrixT m n a = RTree n (RTree m a)

}

\framet{|($@) :: MatrixT N2 N1 Int -> RTree N2 Int -> RTree N1 Int|}{
\vspace{-1ex}
\wfig{4.5in}{figures/applyLin-t21}
}

\framet{|($@) :: MatrixT N2 N2 Int -> RTree N2 Int -> RTree N2 Int|}{
\vspace{-1ex}
\wfig{2.75in}{figures/applyLin-t22}
}

\framet{Composing linear transformations}{

Transform columns:

> (.@) ::  (IsNat m, IsNat n, IsNat o, Num a) =>
>          Matrix n o a -> Matrix m n a -> Matrix m o a
> no .@ mn = transpose ((no SSPACE $@) <$> transpose mn)

More simply and generally,

> (.@) ::  ( Applicative o, Traversable n, Applicative n
>          , Traversable m, Applicative m, Num a ) =>
>          o (n a) -> n (m a) -> o (m a)

}

\framet{|(.@) :: Matrix N3 N4 Int -> Matrix N2 N3 Int -> Matrix N2 N4 Int|}{
\vspace{-1ex}
\wfig{2.3in}{figures/composeLin-v234}
}

\framet{|(.@) :: MatrixT N2 N2 Int -> MatrixT N2 N2 Int -> MatrixT N2 N2 Int|}{
\vspace{-1ex}
\wfig{1.45in}{figures/composeLin-t222}
}

\framet{|(.@) :: MatrixT N3 N2 Int -> MatrixT N2 N3 Int -> MatrixT N2 N2 Int|}{
\vspace{-1ex}
\wfig{1.25in}{figures/composeLin-t232}
}

\framet{Pair sort}{

\vspace{2ex}

> sortP :: Ord a => Unop (Pair a)
> sortP (a :# b) = if a <= b then a :# b else b :# a

\vspace{-6ex}

\wfig{4.2in}{figures/bitonic-up-1}
}

\framet{Bitonic sort}{

> bsort :: (IsNat n, Ord a) => Unop (RTree n a)
> bsort = bsort' nat
> 
> bsort' :: Ord a => Nat n -> Unop (RTree n a)
> bsort' Zero     = id
> bsort' (Succ m) = \ (B ts) ->
>   merge (Succ m) (B (secondP reverse (bsort' m <$> ts)))
> 
> merge :: Ord a => Nat n -> Unop (RTree n a)
> merge n = butterfly' n sortP

> butterfly' :: Ord a => Nat n -> Unop (Pair a) -> Unop (RTree n a)
> butterfly' Zero      _ = id
> butterfly' (Succ m)  f =
>   inB (fmap (butterfly' m f) . (inTranspose.fmap) f)

}

\framet{Bitonic sort --- depth 2}{
\vspace{-3ex}
\wfig{4.75in}{figures/bitonic-up-2}
}

\framet{Bitonic sort --- depth 3}{
\vspace{-5ex}
\wfig{4.75in}{figures/bitonic-up-3}
}

\framet{Bitonic sort --- depth 4}{
\vspace{-1ex}
\wfig{3.75in}{figures/bitonic-up-4}
}

\framet{Parallel scan} {

> class Functor f => LScan f where
>   lscan :: Monoid a => f a -> f a :* a

Instances for functor combinators: |Const|, |Id|, |(:*)|, |(:+)|, |(:.)|.

Specializations:

> lsums :: (LScan f, Num a) => f a -> f a :* a
> lsums = (fmap getSum *** getSum) . lscan . fmap Sum
>
> lsums' :: (LScan f, Traversable f, Num b) => Unop (f b)
> lsums' = snd . shiftR . lsums

%if False

> lproducts :: (LScan f, Num a) => f a -> f a :* a
> lproducts = (fmap getProduct *** getProduct) . lscan . fmap Product

%endif

etc.

}

\framet{|lsums' :: Unop (RTree N4 Int)|}{
\vspace{-2ex}
\wfig{3.3in}{figures/lsumsp-rt4}
}

\framet{|lsums' :: Unop (RTree N5 Int)|}{
\vspace{-4ex}
\wfig{2.6in}{figures/lsumsp-rt5}
}

\framet{|lsums' :: Unop (LTree N4 Int)|}{
\vspace{-1.3ex}
\wfig{4.5in}{figures/lsumsp-lt4}
}

%if False
\framet{Powers}{

> powers :: (LScan f, Applicative f, Num a) => a -> f a
> powers = fst . lproducts . pure

\pause

\vspace{8ex}

|RTree N4 Int|:

\vspace{-22ex}

\wfig{3.2in}{figures/powers-rt4}
}

%else
\framet{Powers}{

> powers :: (LScan f, Applicative f, Num a) => a -> f a
> powers = fst . lproducts . pure

}

\framet{|powers :: Int -> RTree N4 Int| --- unoptimized}{
\vspace{-2ex}
\wfig{4in}{figures/powers-rt4-no-opt}
}
\framet{|powers :: Int -> RTree N4 Int| --- optimized}{
\wfig{4.5in}{figures/powers-rt4}
}

%endif

\framet{Polynomial evaluation}{

> evalPoly ::  (LScan f, Applicative f, Foldable f, Num a) =>
>              f a -> a -> a
> evalPoly coeffs x = coeffs <.> powers x

}

\framet{|evalPoly :: RTree N4 Int -> Int -> Int|}{
\vspace{0ex}
\wfig{4.7in}{figures/evalPoly-rt4}
}

\framet{Synchronous stream transformers}{

% > data Mealy a b = forall s. C s => Mealy ((a,s) -> (b,s)) s

> data Mealy a b = forall s. Mealy ((a,s) -> (b,s)) s

Semantics:

> asStreamFun :: Mealy a b -> StreamArrow (->) a b
> asStreamFun (Mealy f s0) = StreamArrow (go s0)
>  where
>    go s (Cons a as) = Cons b (go s' as) where (b,s') = f (a,s)

Much more generally:

> asArrow :: ArrowCircuit k => Mealy a b -> (a `k` b)
> asArrow (Mealy f s0) = loop (arr f . second (delay s0))

Semantic homomorphism for `Category`, `Arrow`, etc.

}

\framet{Fibonacci}{

> fib :: Num a => Mealy () a

Equivalent definitions:

> fib = Mealy (\ ((),(a,b)) -> (a,(b,a+b))) (0,1)

> fib = loop (arr (\ ((),(a,b)) -> (a,(b,a+b))) . second (delay (0,1)))

> fib = proc () -> do  rec (a,b) <- delay (0,1) -< (b,a+b)
>                      returnA -< a

> fib = proc () -> do  rec  a  <- delay 0  -< b
>                           b  <- delay 1  -< a+b
>                      returnA -< a

}

\framet{Fibonacci}{
\vspace{-2ex}
\wfig{4.7in}{figures/fibS}
}

\framet{Shift register}{

> shiftR :: Traversable t => t a :* a -> a :* t a
> shiftR (as,a') = mapAccumR (flip (,)) a' as

> shiftRS :: Traversable f => f a -> Mealy a a
> shiftRS = Mealy (shiftR . swap)

%% \vspace{-2ex}

\wfig{4.7in}{figures/shiftR-iota-v3}
}

%if False
\framet{CRC}{
\vspace{-2ex}
\wfig{2.2in}{figures/crcSKpp-rt2-shallow-delay-with-depths}
}
%else
\framet{Cyclic redundancy check}{

> crc ::  (Applicative poly, Traversable poly) =>
>         poly Bool -> Mealy Bool (poly Bool)
> crc poly = scanl step (pure False)
>  where
>    step seg b0 = if b0' then liftA2 xor poly seg' else seg'
>     where
>       (b0',seg') = shiftR (seg,b0)

}

\framet{|crc polyD :: Mealy Bool (RTree N2 Bool)| --- unoptimized}{
\wfig{4.5in}{figures/crcSKf-rt2-no-opt}
}

\framet{|crc polyD :: Mealy Bool (RTree N2 Bool)| --- optimized}{
\wfig{4.5in}{figures/crcSKf-rt2}
}

%endif

\framet{Status and future}{

\begin{itemize}\parskip1ex
\item Although Tabula has closed, I'd like the project to continue.
\item Open source \href{https://github.com/conal/lambda-ccc/}{on GitHub}
\item To do:
  \begin{itemize}\parskip1ex
  \item Compiler performance
  \item More examples
% \item Genuine sums for circuits
  \item Memory and computation management
  \item More interpretations (CCCs)
  \end{itemize}
\end{itemize}
}

\end{document}
