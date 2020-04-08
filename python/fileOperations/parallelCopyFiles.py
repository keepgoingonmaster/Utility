import multiprocessing
import traceback
from shutil import copy
import logging
from datetime import datetime
import os
import re


def copyfile(start, end, fileslist, targetfolder):

    if start > end:
        logging.error("index start is greater than end")
        return

    for file in fileslist[start:end]:
        #print(file, targetfolder)
        # if re.search("RWDCache"):
        #     targetfolder = targetfolder + "/RWDCache/"
        copy(file, targetfolder)

def f_callback(start, end):
    print(start, end)


def copyfilesmulti(fileslist, threadsnum, targetfolder):
    try:
        po = multiprocessing.Pool(threadsnum)
        start = 0
        groupSize = int(len(fileslist)/threadsnum)
        for idx in range(threadsnum):
            if idx == threadsnum - 1:
                end = len(fileslist)
            else:
                end = (idx+1) * groupSize

            po.apply_async(func=copyfile, args=(start, end, fileslist, targetfolder), callback=f_callback(start,end))
            start = start + groupSize
        po.close()
        po.join()
    except Exception as e:
        print(traceback.format_exe(e))
        exit()


if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO,
                        format='%(asctime)s.%(msecs)03d - %(name)s  [%(levelname)s] [%(threadName)s] %(message)s',
                        datefmt='%Y-%m-%d %H:%M:%S',
                        filename='copyfilesprocess.log',
                        filemode='w'
                        )

    startTime = datetime.now()

    threadsnum = 32

    sourcefiles = "/opt/mstr/filename.csv"
    targetfolder = "/efs/saas_data/caches/cloud_10s/Serverenv-184346laio1use1_P163613BB4B34BD0B08CE8AB4828EBE97_1M"
    fileslist = []

    documentcachefolder = targetfolder + "/RWDCache"
    if not os.path.exists(targetfolder):
        os.mkdir(targetfolder)
    if not os.path.exists(documentcachefolder):
        os.mkdir(documentcachefolder)

    with open(sourcefiles) as fh:
        for line in fh:
            fileslist.append(line.strip())

    copyfilesmulti(fileslist, threadsnum, documentcachefolder)

    endTime = datetime.now()
    duration = str(endTime - startTime)
    print('test duration is %s',duration)
    logging.info('test duration is %s',duration)
