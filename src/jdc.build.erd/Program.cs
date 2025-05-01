
using LinqToDB.Data;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

using System.CommandLine;
using static jdc.build.erd.Program;
using static LinqToDB.Reflection.Methods;
using System.Runtime.Intrinsics.X86;
using Microsoft.Extensions.Configuration.EnvironmentVariables;
using LinqToDB.SchemaProvider;
using LinqToDB.DataProvider.SapHana;
using System.Runtime.CompilerServices;

namespace jdc.build.erd;

static class Program {

    private static IHost? _host;

    static async Task<int> Main(string[] args) {
        _host = BuildHost();

        var optProvider = new Option<string>(
                name: "--provider",
                description: "The database system to connect to: "
            ) {
            IsRequired = true
        };

        var optConStr = new Option<string>(
                name: "--connectionstring",
                description: "The connectionstring to your database"
            ) {
            IsRequired = true
        };


        var rootCommand = new RootCommand("Generate ERD from a database");
        rootCommand.AddOption(optProvider);
        rootCommand.AddOption(optConStr);


        rootCommand.SetHandler((prov, constr) => { Run(prov, constr); }, optProvider, optConStr);

        return await rootCommand.InvokeAsync(args);

    }

    static IHost BuildHost() {
        return Host.CreateDefaultBuilder()
            .UseConsoleLifetime()
            .Build();
    }

    static void Run(string provider, string constr) {
        _ = _host ?? throw new Exception("init was not ok");

        var lifetime = _host.Services.GetRequiredService<IHostApplicationLifetime>();
        CancellationToken t = lifetime.ApplicationStopping;

        var ctx = new LinqToDB.Data.DataConnection(providerName: provider, connectionString: constr);
        var sp = ctx.DataProvider.GetSchemaProvider();
        var dbSchema = sp.GetSchema(ctx);

        Console.WriteLine("erDiagram");

        var references = new List<Reference>();



        foreach (var table in dbSchema.Tables) {
            var tableName = table.GetFullName();
            Console.WriteLine($"\t\"{tableName}\" {{");

            foreach (var fk in table.ForeignKeys) {
                var thisTableName = fk.ThisTable.GetFullName();
                if (!string.IsNullOrWhiteSpace(thisTableName) && thisTableName.Equals(tableName)) {
                    var otherTableName = fk.OtherTable.GetFullName();
                    if (!string.IsNullOrWhiteSpace(otherTableName)) {
                        references.Add(new(tableName, otherTableName, fk.ToMermaidReference()));
                    }

                }
            }

            foreach (var c in table.Columns) {
                if (c.ColumnType is not null) {
                    var type = c.ColumnType
                        .Replace(" ", "")
                        .Replace(',', '_');
                    Console.WriteLine($"\t\t{type}\t{c.ColumnName}");
                }
            }

            Console.WriteLine("\t}");
        }

        foreach (var r in references) {
            Console.WriteLine($"\"{r.Source}\" {r.Association} \"{r.Destination}\" : \"\"");
        }

    }

}

public static class Extensions {

    public static string ToMermaidReference(this ForeignKeySchema input) {
        if (input.CanBeNull) {
            return input.AssociationType switch {
                AssociationType.ManyToOne => "}|..||",
                AssociationType.OneToOne => "||..||",
                AssociationType.OneToMany => "||..|{",
                AssociationType.Auto => "||..||",
                _ => "||..||"
            };
        } else {
            return input.AssociationType switch {
                AssociationType.ManyToOne => "}o..||",
                AssociationType.OneToOne => "||..||",
                AssociationType.OneToMany => "||..o{",
                AssociationType.Auto => "||..||",
                _ => "||..||"
            };
        }
        
    }

    public static string? GetFullName(this TableSchema? schema) {
        return $"{schema?.SchemaName}.{schema?.TableName}";
    }
}

public record Reference(string Source, string Destination, string Association);
