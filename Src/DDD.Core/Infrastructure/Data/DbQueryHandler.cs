﻿using Conditions;
using System.Data;
using System.Data.Common;
using System.Threading.Tasks;

namespace DDD.Core.Infrastructure.Data
{
    using Application;
    using Threading;

    /// <summary>
    /// Base class for handling database queries.
    /// </summary>
    /// <typeparam name="TQuery">The type of the query.</typeparam>
    /// <typeparam name="TResult">The type of the result.</typeparam>
    /// <seealso cref="IAsyncQueryHandler{TQuery, TResult}" />
    public abstract class DbQueryHandler<TQuery, TResult> : IAsyncQueryHandler<TQuery, TResult>
        where TQuery : class, IQuery<TResult>
    {

        #region Constructors

        /// <summary>
        /// Initializes a new instance of the <see cref="DbQueryHandler{TQuery, TResult}"/> class.
        /// </summary>
        /// <param name="connectionFactory">The database connection factory.</param>
        protected DbQueryHandler(IDbConnectionFactory connectionFactory)
        {
            Condition.Requires(connectionFactory, nameof(connectionFactory)).IsNotNull();
            this.ConnectionFactory = connectionFactory;
        }

        #endregion Constructors

        #region Properties

        protected IDbConnectionFactory ConnectionFactory { get; }

        #endregion Properties

        #region Methods

        public async Task<TResult> HandleAsync(TQuery query)
        {
            Condition.Requires(query, nameof(query)).IsNotNull();
            await new SynchronizationContextRemover();
            try
            {
                using (var connection = await this.ConnectionFactory.CreateOpenConnectionAsync())
                {
                    return await this.ExecuteAsync(query, connection);
                }
            }
            catch(DbException ex)
            {
                throw new QueryException(ex, query);
            }

        }

        protected abstract Task<TResult> ExecuteAsync(TQuery query, IDbConnection connection);

        #endregion Methods

    }
}