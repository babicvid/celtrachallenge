import pymysql
import re
from flask import Flask, make_response
from flask_restful import Resource, Api, abort


# Init and connection to database
cnxn = pymysql.connect(db='sql11224596', user='sql11224596', passwd='uk9tTAEbRl', host='sql11.freemysqlhosting.net', port=3306)
cursor = cnxn.cursor()
app = Flask(__name__)
api = Api(app)


# Specific camapign / all time
class SpecCampAllTime(Resource):
    def get(self, camp, fields):
        # Check if camp is numeric
        if not camp.isdigit():
            abort(403, message='Campaign ID must be a number')

        # Check for required fields
        # Delete everything but commas and letters
        fields = re.sub(r'[^a-z,]', '', fields.lower()).split(",")

        impressions = ", count(*) as impressions" if "impressions" in fields else ""
        interactions = ", sum(swipeno + pinchno + touchno + clickno) as interactions" if "interactions" in fields else ""
        swipes = ", sum(swipeno) as swipes" if "swipes" in fields else ""
        pinches = ", sum(pinchno) as pinches" if "pinches" in fields else ""
        touches = ", sum(touchno) as touches" if "touches" in fields else ""
        clicks = ", sum(clickno) as clicks" if "clicks" in fields else ""
        uniqueusers = ", count(distinct user) as uniqueusers" if "uniqueusers" in fields else ""

        # Execute query
        cursor.execute("""select campaignid as campaign , adid as ad %s %s %s %s %s %s %s
                          from impression
                          where campaignid = %d
                          group by campaignid, adid""" % (impressions, interactions, swipes, pinches, touches, clicks, uniqueusers, int(camp)))

        # Extract headers
        row_headers = [x[0] for x in cursor.description]
        rv = cursor.fetchall()
        # Check for empty response
        if len(rv) == 0:
            abort(403, message='Campaign does not exist or does not have any ads')
        # Create and send response
        # Using GET requests and plaintext responses for easier testing
        data = ",".join(row_headers) + "\n"
        for result in rv:
            data += ",".join([str(x) for x in result]) + "\n"
        response = make_response(data)
        response.content_type = "text/plain"
        return response


# All campaigns / last week
class AllCampWeek(Resource):
    def get(self, fields):
        # Check for required fields
        fields = re.sub(r'[^a-zA-Z,]', '', fields).split(",")

        impressions = ", count(*) as impressions" if "impressions" in fields else ""
        interactions = ", sum(swipeno + pinchno + touchno + clickno) as interactions" if "interactions" in fields else ""
        swipes = ", sum(swipeno) as swipes" if "swipes" in fields else ""
        pinches = ", sum(pinchno) as pinches" if "pinches" in fields else ""
        touches = ", sum(touchno) as touches" if "touches" in fields else ""
        clicks = ", sum(clickno) as clicks" if "clicks" in fields else ""

        # Execute query
        cursor.execute("""select campaignid as campaign, adid as ad, date(impressiontimestamp) as date %s %s %s %s %s %s
                          from impression
                          where date(impressiontimestamp) >= curdate() - INTERVAL DAYOFWEEK(curdate())+7 DAY
                          group by date(impressiontimestamp), campaignid, adid
                          order by 1,2,3""" % (impressions, interactions, swipes, pinches, touches, clicks))

        # Extract headers
        row_headers = [x[0] for x in cursor.description]
        rv = cursor.fetchall()

        if "uniqueusers" in fields:
            # Get unique users data
            cursor.execute("""select A.campaign, A.ad, A.date, B.uniqueusers 
                            from (select campaignid as campaign, adid as ad, date(impressiontimestamp) as date, count(*) as impressions, sum(swipeno + pinchno + touchno + clickno) as interactions, sum(swipeno) as swipes, sum(pinchno) as pinches, sum(touchno) as touches, sum(clickno) as clicks
                            from impression
                            where date(impressiontimestamp) >= curdate() - INTERVAL DAYOFWEEK(curdate())+7 DAY
                            group by date(impressiontimestamp), campaignid, adid
                            order by 1,2,3) as A left join
                            (select I1.campaignid as campaign, I1.adid as ad, date(I1.impressiontimestamp) as date, count(distinct I1.user) as uniqueusers
                            from impression I1
                            where I1.user not in
                            (select I2.user
                            from impression I2
                            where I1.campaignid = I2.campaignid and I1.adid = I2.adid and date(I1.impressiontimestamp) > date(I2.impressiontimestamp))
                            and date(I1.impressiontimestamp) > curdate() - INTERVAL DAYOFWEEK(curdate())+7 DAY
                            group by I1.campaignid, I1.adid, date(I1.impressiontimestamp)
                            order by 1,2,3) as B
                            on A.campaign=B.campaign AND A.ad=B.ad AND A.date=B.date""")

            row_headers.append("uniqueusers")
            uu = cursor.fetchall()
            temp = ()
            for x in range(len(rv)):
                usercount = 0 if uu[x][3] is None else uu[x][3]
                temp = temp + ((rv[x] + (usercount,)),)
            rv = temp

        # Check for empty response
        if len(rv) == 0:
            abort(403, message='No data')
        # Create and send response
        data = ",".join(row_headers) + "\n"
        for result in rv:
            data += ",".join([str(x) for x in result]) + "\n"
        response = make_response(data)
        response.content_type = "text/plain"
        return response

# Customer info
class CustInfo(Resource):
    def get(self, id):
        # Check if id is numeric
        if not id.isdigit():
            abort(403, message='Customer ID must be a number')
        # Execute query
        cursor.execute("""select customerid as id, customername as name, customeraddress as address
                          from customer
                          where customerid = %d""" % int(id))
        # Extract headers
        row_headers = [x[0] for x in cursor.description]
        rv = cursor.fetchall()
        # Create and send response
        return createResponse(row_headers, rv)

# Campaign info
class CampInfo(Resource):
    def get(self, id):
        # Check if id is numeric
        if not id.isdigit():
            abort(403, message='Campaign ID must be a number')
        # Execute query
        cursor.execute("""select campaignid as id, campaigndescription as description, date(startdate) as startdate, date(enddate) as enddate, active, customerid
                          from campaign
                          where campaignid = %d""" % int(id))
        # Extract headers
        row_headers = [x[0] for x in cursor.description]
        rv = cursor.fetchall()
        # Create and send response
        return createResponse(row_headers, rv)

# Ad info
class AdInfo(Resource):
    def get(self, id):
        # Check if id is numeric
        if not id.isdigit():
            abort(403, message='Ad ID must be a number')
        # Execute query
        cursor.execute("""select adid as id, adname as name, date(startdate) as startdate, date(enddate) as enddate, active, campaignid
                          from ad
                          where adid = %d""" % int(id))
        # Extract headers
        row_headers = [x[0] for x in cursor.description]
        rv = cursor.fetchall()
        # Create and send response
        return createResponse(row_headers, rv)

# Create response helper function
def createResponse(row_headers, rv):
    # Check for empty response
    if len(rv) == 0:
        abort(403, message='No data, check ID')
    # Create and send response
    data = ",".join(row_headers) + "\n"
    for result in rv:
        data += ",".join([str(x) for x in result]) + "\n"
    response = make_response(data)
    response.content_type = "text/plain"
    return response

# Add routes
api.add_resource(SpecCampAllTime, '/single-all/<camp>/<fields>/')  # Route 1
api.add_resource(AllCampWeek, '/all-week/<fields>/')  # Route 2
api.add_resource(CustInfo, '/customer-info/<id>/')  # Route 3
api.add_resource(CampInfo, '/campaign-info/<id>/')  # Route 4
api.add_resource(AdInfo, '/ad-info/<id>/')  # Route 5

if __name__ == '__main__':
    app.run(port=5002)
    cnxn.close()
