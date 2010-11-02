\name{ae-to-be}
\alias{ae-to-be}
\alias{protectwords}
\alias{Simple}
\alias{OxEnglish}
\alias{BritishEnglish}
\alias{Simpleplus}
\alias{zwords}
\alias{re_zwords}
\alias{unprotectwords}
\encoding{UTF-8}
\title{American English to British English}
\description{Transforms American English spelling into British English spelling.}
\usage{
\item{Simple(txt)}{}
\item{Simpleplus(txt)}{}
\item{OxEnglish(txt)}{}
\item{BritishEnglish(txt)}{}
}
\arguments{
\item{txt}{A vector of character strings.}
}
\value{Returns \code{txt} in British English spelling.}
\source{\url{http://en.wikipedia.org/wiki/User:Ohconfucius/EngvarB.js}}
\author{Angela Bohn \email{angela.bohn at gmail.com}}
\examples{
Simple("analyze")
}