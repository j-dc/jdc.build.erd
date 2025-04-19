
using LinqToDB.Data;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

using System.CommandLine;
using static jdc.build.erd.Program;
using static LinqToDB.Reflection.Methods;
using System.Runtime.Intrinsics.X86;
using Microsoft.Extensions.Configuration.EnvironmentVariables;

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


        rootCommand.SetHandler( (prov, constr) => {  Run(prov, constr); }, optProvider, optConStr);

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

        foreach (var table in dbSchema.Tables) {
            Console.WriteLine($"\t\"{table.SchemaName}.{table.TableName}\" {{");

            foreach (var c in table.Columns) {
                var type = c.ColumnType
                    .Replace(" ","")
                    .Replace(',','_');
                Console.WriteLine($"\t\t{c.ColumnType}\t{c.ColumnName}");

            }

            Console.WriteLine("\t}");
        }

        

      

    }

}
