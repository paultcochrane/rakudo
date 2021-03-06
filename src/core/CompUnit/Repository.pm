role CompUnit::Repository {
    has CompUnit::Repository $.next-repo is rw;

    # Resolves a dependency specification to a concrete dependency. If the
    # dependency was not already loaded, loads it. Returns a CompUnit
    # object that represents the selected dependency. If there is no
    # matching dependency, throws X::CompUnit::UnsatisfiedDependency.
    method need(CompUnit::DependencySpecification $spec,
                # If we're first in the chain, our precomp repo is the chosen one.
                CompUnit::PrecompilationRepository $precomp = self.precomp-repository())
        returns CompUnit:D
        { ... }

    # Just load the file and return a CompUnit object representing it.
    method load(IO::Path:D $file)
        returns CompUnit:D
    {
        return self.next-repo.load($file) if self.next-repo;
        nqp::die("Could not find $file in:\n" ~ $*REPO.repo-chain.map(*.Str).join("\n").indent(4));
    }

    # Returns the CompUnit objects describing all of the compilation
    # units that have been loaded by this repository in the current
    # process.
    method loaded()
        returns Iterable
        { ... }

    # Returns a unique ID of this repository
    method id()
        returns Str
        { ... }

    method precomp-repository()
        returns CompUnit::PrecompilationRepository
        { CompUnit::PrecompilationRepository::None }

    method repo-chain() {
        ($.next-repo and $.next-repo.defined) ?? (self, |$.next-repo.repo-chain()) !! (self, );
    }
}

# vim: ft=perl6 expandtab sw=4
